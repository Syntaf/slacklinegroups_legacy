class AdminController < ApplicationController
    before_action :authenticate
    
    def new
        @group = Group.new
    end

    def edit
        @group = Group.find(params[:id])
        p @group.cords
    end

    def create
        @group = Group.new(group_params)

        if @group.save
            redirect_to @group
        else
            render 'new'
        end
    end

    def update
        @group = Group.find(params[:id])

        if @group.update(group_params)
            redirect_to @group
        else
            render 'edit'
        end
    end

    def show
        @group = Group.find(params[:id])
    end

    def index
        p ENV
        @groups = Group.all
    end

    def destroy
        @group = Group.find(params[:id])
        @group.destroy

        redirect_to groups_path
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

        def authenticate
            authenticate_or_request_with_http_basic do |username, password|
                username == ENV['GROUP_USERNAME'] && password == ENV['GROUP_PASSWORD']
            end
        end
end
