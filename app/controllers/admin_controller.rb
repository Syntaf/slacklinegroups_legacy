class AdminController < ApplicationController
    # before_action :authenticate
    
    def index
        p Rails.application.routes.named_routes.helper_names
        @groups = Group.all

        # status of 1 in approval field represents pending status. 0 = approved, 2 = rejected
        @userSubmittedGroups = UserSubmittedGroup.where(approved: 0)
    end

    def new
        @group = Group.new
    end

    def edit
        @group = Group.find(params[:id])
    end

    def create
        @group = Group.new(group_params)

        if @group.save
            p @group
            redirect_to admin_path(@group)
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
            cords: @apprGroup.cords
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
        def cords_to_a
            # get the params[:group][:cords], if empty use '[]'
            cords = params.dig(:group, :cords).presence || "[]"
            JSON.parse cords
        end

        def group_params
            params.require(:group).permit(:name, :members, :centroid_lat, :centroid_lon, :fb_group, :fb_page, :website, :isRegional)
        end

        def authenticate
            authenticate_or_request_with_http_basic do |username, password|
                username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
            end
        end
end
