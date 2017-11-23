require "json"

class GroupsController < ApplicationController

    # Don't allow an index path for groups, instead redirect to admin
    def index
        redirect_to admin_index_path
    end

    def new
        @group = SubmittedGroup.new
    end

    # Never actually delete a user submitted group. Setting the approved
    # tag to 2 will mean the group was rejected, and no longer show it
    # in the admin pending panel
    def destroy
        @group = SubmittedGroup.find(params[:id])
        @group.save

        redirect_to admin_index_path
    end

    # Grabs the corresponding group for displaying use in the template
    def show
        @group = SubmittedGroup.find(params[:id])
    end

    # Attempts to submit a group from a user. If successful, sends back a local
    # which is used to open a prompt if true.
    def create
        @group = SubmittedGroup.new(group_params)

        if @group.save
            render 'new', locals: { successfullSubmit: true }
        else
            render 'new'
        end
    end

    private
        def group_params
            params.require(:submitted_group).permit(:name, :members, :group_type, :lat, :lon, :link, :is_regional, :email)
        end
end
