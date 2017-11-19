require 'json'
require 'net/http'
require 'base_map_controller'

class MapController < BaseMap
    # before_action :authenticate

    def index
        @json = Array.new
        # if params[:id] != nil
        #     p 'inside here'
        #     @group = Group.find(params[:id])
        #     link = @group.fb_group
        #     type = "Group"
        #     members = @group.members
        #     if !link || link.blank?
        #         type = "Page"
        #         members = "N/A"
        #         link = @group.fb_page
        #     end
        #     if !link || link.blank?
        #         type = "Website"
        #         members = "N/A"
        #         link = @group.website
        #     end
    
        #     @json << {
        #         features:
        #         [
        #             {
        #                 geometry:
        #                 {
        #                     coordinates: @group.cords? ? centroid(@group.cords) : [@group.centroid_lon.to_f, @group.centroid_lat.to_f]
        #                 },
        #                 properties:
        #                 {
        #                     name: @group.name,
        #                     link: link,
        #                     members: members,
        #                     type: type,
        #                     id: @group.id
        #                 }
        #             }
        #         ],
        #         fromSearch: true
        #     }
        # end
        javascript_variables(group: @json)
        p Rails.application.routes.named_routes.helper_names
    end

    def groupinfo
        @group = Group.find(params[:id])
        @json = Array.new
        # link = @group.fb_group
        # type = "Group"
        # members = @group.members
        # if !link || link.blank?
        #     type = "Page"
        #     members = "N/A"
        #     link = @group.fb_page
        # end
        # if !link || link.blank?
        #     type = "Website"
        #     members = "N/A"
        #     link = @group.website
        # end

        # @json << {
        #     features:
        #     [
        #         {
        #             geometry:
        #             {
        #                 coordinates: @group.cords? ? centroid(@group.cords) : [@group.centroid_lon.to_f, @group.centroid_lat.to_f]
        #             },
        #             properties:
        #             {
        #                 name: @group.name,
        #                 link: link,
        #                 members: members,
        #                 type: type,
        #                 id: @group.id
        #             }
        #         }
        #     ]
        # }

        render 'index', :group => @json
    end

    def getclusters
        super
    end

    def pointclouds
        @groups = Group.all
        @geojson = Array.new

        # @groups.each do |group|
        #     if group.cords? || (group.centroid_lat? && group.centroid_lon?)
        #         type = "Group"
        #         members = group.members
        #         link = group.fb_group
        #         if !link || link.blank?
        #             type = "Page"
        #             members = "N/A"
        #             link = group.fb_page
        #         end
        #         if !link || link.blank?
        #             type = "Website"
        #             members = "N/A"
        #             link = group.website
        #         end
        #         @geojson << {
        #             type: 'Feature',
        #             geometry: {
        #                 type: 'Point',
        #                 coordinates: group.cords? ? centroid(group.cords) : [group.centroid_lon.to_f, group.centroid_lat.to_f]
        #             },
        #             properties: {
        #                 name: group.name,
        #                 members: members,
        #                 type: type,
        #                 link: link,
        #                 id: group.id,
        #                 isRegional: group.isRegional
        #             }
        #         }
        #     end
        # end

        # respond_to do |format|
        #     format.html
        #     format.json { render :json => @geojson }
        # end
    end
end
