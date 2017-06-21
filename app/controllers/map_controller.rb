require 'json'

class MapController < ApplicationController
    before_action :authenticate

    def index
        p Rails.application.routes.named_routes.helper_names
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

    def pointclouds
        @groups = Group.all
        @geojson = Array.new

        @groups.each do |group|
            if !group.cords.empty?
                @geojson << {
                    type: 'Feature',
                    geometry: {
                        type: 'Point',
                        coordinates: centroid(group.cords)
                    }
                }
            end
        end

        respond_to do |format|
            format.html
            format.json { render :json => @geojson }
        end
    end

    private
        def centroid(poly)
            centroid = [0.0, 0.0]
            signedArea = x0 = y0 = x1 = y1 = a = 0.0
            for i in 0..(poly[0].length-2) do
                x0 = poly[0][i][0];
                y0 = poly[0][i][1];
                x1 = poly[0][i+1][0];
                y1 = poly[0][i+1][1];
                a = x0*y1 - x1*y0;
                signedArea += a;
                centroid[0] += (x0 + x1)*a;
                centroid[1] += (y0 + y1)*a;
            end

            x0 = poly[0][poly[0].length-1][0];
            y0 = poly[0][poly[0].length-1][1];
            x1 = poly[0][0][0];
            y1 = poly[0][0][1];
            a = x0*y1 - x1*y0;
            signedArea += a;
            centroid[0] += (x0 + x1)*a;
            centroid[1] += (y0 + y1)*a;

            signedArea *= 0.5;
            centroid[0] /= (6.0 * signedArea);
            centroid[1] /= (6.0 * signedArea);

            centroid
        end

        def authenticate
            authenticate_or_request_with_http_basic do |username, password|
                username == ENV['TEMP_USERNAME'] && password == ENV['TEMP_PASSWORD']
            end
        end
end
