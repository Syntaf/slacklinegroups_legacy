require 'json'

group_file = File.read('./db/old_user_group_seeds.rb')
data_hash = JSON.parse(group_file)

data_hash['groups'].each do |group|
    type = 'N/A'
    link = 'N/A'
    ngroup = nil

    if group['approved'] == 0
        ngroup = SubmittedGroup.new
    else
        ngroup = SubmittedGroupHistory.new

        if group['approved'] == 1
            ngroup.approved = true
            ngroup.reason = 'Approved'
        elsif group['approved'] == 2
            ngroup.approved = false
            ngroup.reason = 'Denied'
        end
    end

    ngroup.name = group['name']
    ngroup.members = group['members']
    ngroup.is_regional = group['is_regional']
    ngroup.email = group['email']

    ngroup.lat = group['centroid_lat']
    ngroup.lon = group['centroid_lon']
    
    if group['fb_group'] != nil && group['fb_group'] != ""
        ngroup.link = group['fb_group']
        ngroup.group_type = 'facebook group'
    elsif group['fb_page'] != nil && group['fb_page'] != ""
        ngroup.link = group['fb_page']
        ngroup.group_type = 'facebook page'
    else
        ngroup.link = group['website']
        ngroup.group_type = 'website'
    end

    ngroup.created_at = group['created_at']
    ngroup.updated_at = group['updated_at']

    ngroup.save
end