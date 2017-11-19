require 'json'

group_file = File.read('./db/old_group_seeds.rb')
data_hash = JSON.parse(group_file)

data_hash['groups'].each do |group|
    type = 'N/A'
    link = 'N/A'
    ngroup = Group.new
    ngroup.id = group['id']
    ngroup.save
    
    if group['fb_group'] != nil
        link = group['fb_group']
        type = 'facebook group'
    elsif group['fb_page'] != nil
        link = group['fb_page']
        type = 'facebook page'
    else group['website'] != nil
        link = group['website']
        type = 'website'
    end
    ngroup.create_info(link: link, members: group['members'])
    ngroup.create_location(lat: group['centroid_lat'], lon: group['centroid_lon'])
    
    ngroup.created_at = group['created_at']
    ngroup.updated_at = group['updated_at']
    ngroup.name = group['name']
    ngroup.group_type = type
    ngroup.save
end