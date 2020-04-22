require 'base_map_controller'

class EmbeddedMapController < BaseMap
  # Most functionality is implemented within BaseMap, what's left here is specific to the
  # root map and not the embeded map

  # Displays the slacklinegroups map and checks if the user asked for a specific group. If
  # a group id is detected, grab that groups info and send it along javascript_variables
  def index
    # @json = Array.new

    params.permit(:id, :showSearchBar, :showHome, :center, :zoom)
    if params[:id] != nil
      params[:group] = self.class.superclass.instance_method(:get_group).bind(self).call
    end

    # Supply global JS variable which can be grabbed by map.js
    javascript_variables(params.as_json)
  end

  # Calls the super class to return a MapBox formatted JSON list of all slacklinegroups
  # in the database
  def clusters
    super
  end
end
