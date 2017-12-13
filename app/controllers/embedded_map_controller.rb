require 'base_map_controller'

class EmbeddedMapController < BaseMap
    # Most functionality is implemented within BaseMap, what's left here is specific to the
    # root map and not the embeded map

    # Displays the slacklinegroups map and checks if the user asked for a specific group. If
    # a group id is detected, grab that groups info and send it along javascript_variables
    def index
        # @json = Array.new

        params.permit(:group)
        if params[:id] != nil
            params[:group] = self.class.superclass.instance_method(:get_group).bind(self).call
        end
        
        p params
        # params.permit(:showSearchBar, :showHome, :center, :group)
        # p params.as_json.merge!({group: @json})

        # Supply global JS variable which can be grabbed by map.js
        javascript_variables(params.as_json)
    end

    # Calls the super class to return a MapBox formatted JSON list of all slacklinegroups
    # in the database
    def clusters
        super
    end
end
