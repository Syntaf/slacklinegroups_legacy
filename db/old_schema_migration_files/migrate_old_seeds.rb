require 'json'

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

group_file = File.read('./db/old_group_seeds.rb')
data_hash = JSON.parse(group_file)

data_hash['groups'].each do |group|
  type = 'N/A'
  link = 'N/A'
  ngroup = Group.new
  ngroup.id = group['id']
  ngroup.save
  
  if group['fb_group'] != nil && group['fb_group'] != ""
    link = group['fb_group']
    type = 'facebook group'
  elsif group['fb_page'] != nil && group['fb_page'] != ""
    link = group['fb_page']
    type = 'facebook page'
  else
    link = group['website']
    type = 'website'
  end
  ngroup.create_info(link: link, members: group['members'], is_regional: group['isRegional'])
  if group['cords'].length > 0
    p group['cords']
    from_centroid = centroid(group['cords'])
    ngroup.create_location(lat: from_centroid[1], lon: from_centroid[0])
  else
    ngroup.create_location(lat: group['centroid_lat'], lon: group['centroid_lon'])
  end
  ngroup.created_at = group['created_at']
  ngroup.updated_at = group['updated_at']
  ngroup.name = group['name']
  ngroup.group_type = type
  ngroup.save
end