require 'json'

group_file = File.read('./db/old_group_seeds.rb')
data_hash = JSON.parse(group_file)

data_hash['groups'].each do |group|
    type = 'N/A'
    ninfo = Info.new
    if group['fb_group'] != nil
        ninfo.link = group['fb_group']
        type = 'facebook group'
    elsif group['fb_page'] != nil
        ninfo.link = group['fb_page']
        type = 'facebook page'
    else group['website'] != nil
        ninfo.link = group['website']
        type = 'website'
    end
    ninfo.members = group['members']
    ninfo.save

    nloc = Location.new
    nloc.lat = group['centroid_lat']
    nloc.lon = group['centroid_lon']
    nloc.save

    ngroup = Group.new
    ngroup.id = group['id']
    ngroup.created_at = group['created_at']
    ngroup.updated_at = group['updated_at']
    ngroup.name = group['name']
    ngroup.group_type = type
    ngroup.location_id = nloc.id
    ngroup.info_id = ninfo.id
    ngroup.save
end