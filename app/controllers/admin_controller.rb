class AdminController < ApplicationController
    #before_action :authenticate
    
    def index
        @groups = Group.joins(:info, :location).includes(:info, :location)

        @userSubmittedGroups = SubmittedGroup.all
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

        @approvedGroup = SubmittedGroup.find(params[:id])

        # Create new group and relationships using submitted group information
        @newGroup = Group.new(
            name: @approvedGroup.name,
            group_type: @approvedGroup.group_type
        )

        @newGroup.create_info(
            members: @approvedGroup.members,
            link: @approvedGroup.link,
            is_regional: @approvedGroup.is_regional
        )

        @newGroup.create_location(
            lat: @approvedGroup.lat,
            lon: @approvedGroup.lon
        )

        if @newGroup.save
            # Create a history entry for the submitted group
            @historyEntry = SubmittedGroupHistory.new(
                name: @approvedGroup.name,
                group_type: @approvedGroup.group_type,
                reason: 'Approved',
                lat: @approvedGroup.lat,
                lon: @approvedGroup.lon,
                link: @approvedGroup.link,
                email: @approvedGroup.email,
                members: @approvedGroup.members,
                approved: true,
                is_regional: @approvedGroup.is_regional,
                verified_time: DateTime.now
            )
            if @historyEntry.save
                # Save successful, meaning we can now delete the submit entry
                @approvedGroup.destroy

                # Return success response with new group info so it can be added during AJAX call
                @response = {
                    status: 200,
                    group: @newGroup.as_json
                }
            else
                @response = {
                    status: 500,
                    errors: @historyEntry.errors.full_messages
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
            params.require(:group).permit(:name, :group_type, location_attributes: [:lat, :lon], info_attributes: [:members, :link, :is_regional])
        end

        def authenticate
            authenticate_or_request_with_http_basic do |username, password|
                username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
            end
        end
end
