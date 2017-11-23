class AdminController < ApplicationController
    # before_action :authenticate
    
    def index
        p Rails.application.routes.named_routes.helper_names
        @groups = Group.joins(:info, :location).includes(:info, :location)

        # status of 1 in approval field represents pending status. 0 = approved, 2 = rejected
        @userSubmittedGroups = SubmittedGroup.where(approved: 0)
    end

    def new
        @group = Group.new
        @group.build_info
        @group.build_location
    end

    def edit
        @group = Group.find(params[:id])
    end

    def create
        @group = Group.new(group_params)
        @group.create_info(info_params)
        @group.create_location(location_params)

        if @group.save
            p @group
            redirect_to admin_index_path
        else
            render 'new'
        end
    end

    def update
        @group = Group.find(params[:id])

        if @group.update(group_params)
            redirect_to admin_index_path
        else
            render 'edit'
        end
    end

    def show
        @group = Group.find(params[:id])
    end

    def destroy
        @group = Group.find(params[:id])
        @group.destroy

        redirect_to admin_index_path
    end

    def approve
        @response = Array.new

        @apprGroup = UserSubmittedGroup.find(params[:id])

        @newGroup = Group.new(
            name: @apprGroup.name,
            fb_group: @apprGroup.fb_group,
            fb_page: @apprGroup.fb_page,
            website: @apprGroup.website,
            centroid_lat: @apprGroup.centroid_lat,
            centroid_lon: @apprGroup.centroid_lon,
            members: @apprGroup.members,
        )

        if @newGroup.save
            @apprGroup.approved = 1
            if @apprGroup.save
                @response = {
                    status: 200,
                    group: @newGroup.as_json
                }
            else
                @response = {
                    status: 500,
                    errors: @apprGroup.errors.full_messages
                }
            end
        else
            @response = {
                status: 500,
                errors: @newGroup.errors.full_messages
            }
        end

        respond_to do |format|
            format.html
            format.json { render :json => @response }
        end
    end

    private
        def group_params
            params.require(:group).permit(:name, :group_type)
        end

        def info_params
            params.require(:info).permit(:link, :members, :is_regional)
        end

        def location_params
            params.require(:location).permit(:lat, :lon)
        end

        def authenticate
            authenticate_or_request_with_http_basic do |username, password|
                username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
            end
        end
end
