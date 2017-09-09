require "json"

class GroupsController < ApplicationController

    def index
        @groups = UserSubmittedGroup.all
    end

    def new
        # helpers = Rails.application.routes.named_routes.helper_names
        # p helpers
        @group = UserSubmittedGroup.new
    end

    def destroy
        @group = UserSubmittedGroup.find(params[:id])
        @group.destroy()
    end

    def show
        @group = Group.find(params[:id])
    end

    def create
        @group = UserSubmittedGroup.new(group_params)

        if @group.save
            render 'new', locals: { successfullSubmit: true }
        else
            render 'new'
        end
    end

    def show
        @group = UserSubmittedGroup.find(params[:id])
    end

    private
        def cords_to_a
            # get the params[:group][:cords], if empty use '[]'
            cords = params.dig(:user_submitted_group, :cords).presence || "[]"
            JSON.parse cords
        end

        def group_params
            params.require(:user_submitted_group).permit(:name, :members, :centroid_lat, :centroid_lon, :fb_group, :fb_page, :website, :isRegional, :email).merge({cords: cords_to_a})
        end
end
