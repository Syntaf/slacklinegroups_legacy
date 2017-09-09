require "json"

class GroupsController < ApplicationController

    def new
        @group = UserSubmittedGroup.new
    end

    def edit
        @group = UserSubmittedGroup.find(params[:id])
        p @group.cords
    end

    def update
        @group = UserSubmittedGroup.find(params[:id])

        if @group.update(group_params)
            redirect_to @group
        else
            render 'edit'
        end
    end

    def show
        @group = UserSubmittedGroup.find(params[:id])
    end

    private
        def cords_to_a
            # get the params[:group][:cords], if empty use '[]'
            cords = params.dig(:group, :cords).presence || "[]"
            JSON.parse cords
        end

        def group_params
            params.require(:group).permit(:name, :members, :link).merge({cords: cords_to_a})
        end
end
