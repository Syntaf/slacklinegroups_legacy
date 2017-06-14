require 'json'

class MapController < ApplicationController
    def index
    end

    def groups
        @groups = Group.all
        @geojson = Array.new

        @groups.each do |group|
            @geojson << {
                type: 'Feature',
                geometry: {
                    type: 'Polygon',
                    coordinates: group.cords
                },
                properties: {
                    name: group.name,
                    members: group.members
                }
            }
        end

        respond_to do |format|
            format.html
            format.json { render :json => @geojson }
        end
    end
end
