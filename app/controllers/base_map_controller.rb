require 'json'

class BaseMap < ApplicationController

    # Grabs all groups from the database and places them into a MapBox formatted
    # JSON list.
    def clusters
        @groups = Group.joins(:info, :location).includes(:info, :location)
        @geojson = Array.new

        @groups.each do |group|
            if group.location.lat? && group.location.lon?
                # type of group requires special processing and formatting
                group.group_type = get_type(group.group_type)

                # append mapbox compatible feature
                @geojson << format_entity(group)
            end
        end

        respond_to do |format|
            format.html
            format.json { render :json => @geojson }
        end
    end

    # Gets information for a specific group, and returns a MapBox formatted JSON
    # object.
    def get_group
        p params[:id]
        @group = Group
            .joins(:info, :location)
            .includes(:info, :location)
            .find(params[:id])

        return {
            features:
            [
                {
                    geometry:
                    {
                        coordinates: [@group.location.lon.to_f, @group.location.lat.to_f]
                    },
                    properties:
                    {
                        name: @group.name,
                        link: @group.info.link,
                        members: @group.info.members? ? @group.info.members : 'N/A',
                        type: get_type(@group.group_type),
                        id: @group.id,
                        is_regional: @group.info.is_regional
                    }
                }
            ]
        }
    end

    private
        # Group types go through extra processing to shorten their names
        def get_type(begin_type)
            case begin_type
            when 'facebook group'
                return 'Group'
            when 'facebook page'
                return 'Page'
            end
            return begin_type.capitalize
        end

        # Formats a single group entity into a MapBox feature object
        def format_entity(entity)
            return {
                type: 'Feature',
                geometry: {
                    type: 'Point',
                    coordinates: [entity.location.lon.to_f, entity.location.lat.to_f]
                },
                properties: {
                    id: entity.id,
                    name: entity.name,
                    type: entity.group_type,
                    members: entity.info.members? ? entity.info.members : 'N/A',
                    link: entity.info.link,
                    is_regional: entity.info.is_regional 
                }
            }
        end
end