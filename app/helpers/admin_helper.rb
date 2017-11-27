module AdminHelper
    def missing_information(group)
        return group.info.link == nil ||
            (group.group_type == "facebook group" && group.info.members == nil) ||
            group.location.lat == nil ||
            group.location.lon == nil
    end

    def shrink_type(type)
        if type == 'facebook group'
            return 'Group'
        elsif type == 'facebook page'
            return 'Page'
        else
            return 'Other'
        end
    end
end
