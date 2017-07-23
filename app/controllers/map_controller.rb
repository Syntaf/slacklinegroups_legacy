require 'json'
require 'net/http'

class MapController < ApplicationController
    # before_action :authenticate

    def index
        p Rails.application.routes.named_routes.helper_names
    end

    def cover
        url = URI.parse('https://graph.facebook.com/798358306957010?fields=cover&access_token=207399369789132|df69dfde8f407634938eb426cd932c1d')
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port, :use_ssl => true) { |http|
            http.request(req)
        }
        p res;
        respond_to do |format|
            format.html
            format.json { render :json => res.body }
        end
    end

    def groups
        @groups = Group.all
        @geojson = Array.new

        @groups.each do |group|
            if !group.cords.empty?
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
            if group.cords? || (group.centroid_lat? && group.centroid_lon?)
                type = "Group"
                members = group.members
                link = group.fb_group
                if !link || link.blank?
                    type = "Page"
                    members = "N/A"
                    link = group.fb_page
                end
                if !link || link.blank?
                    type = "Website"
                    members = "N/A"
                    link = group.website
                end
                @geojson << {
                    type: 'Feature',
                    geometry: {
                        type: 'Point',
                        coordinates: group.cords? ? centroid(group.cords) : [group.centroid_lon.to_f, group.centroid_lat.to_f]
                    },
                    properties: {
                        name: group.name,
                        members: members,
                        type: type,
                        link: link,
                        isRegional: group.isRegional
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
