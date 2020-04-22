# frozen_string_literal: true

require 'fileutils'

namespace :dataset do
  desc 'Matches database against Ryan\'s larger dataset'
  task match: :environment do
    require 'csv'

    matches = [['Country/State', 'City/Region', 'Group Name', 'Link', 'Latitude', 'Longitude', 'Merged?', 'Map Link']]

    csv_dataset = File.read('merge_dataset.csv')
    csv = CSV.parse(csv_dataset, headers: true)
    csv.each do |row|
      link = trim_link(row['Link']) unless row['Link'].nil?

      next if link.nil?

      groups = Group.joins(:info).joins(:location).where('info.link LIKE ?', "%#{link}%")

      if groups.one?
        group = groups.first
        row['Latitude'] = group.location.lat
        row['Longitude'] = group.location.lon
        row['Merged?'] = 'Yes'
        row['Map Link'] = "https://www.google.com/maps/@#{group.location.lat.to_s},#{group.location.lon.to_s},15z"

        matches << row.to_hash.map { |_key, value| value }
      elsif groups.many?
        groups.each do |group|
          row['Latitude'] = group.location.lat
          row['Longitude'] = group.location.lon
          row['Merged?'] = 'CONFLICT'
          row['Map Link'] = "https://www.google.com/maps/@#{group.location.lat.to_s},#{group.location.lon.to_s},15z"

          matches << row.to_hash.map { |_key, value| value }
        end
      else
        row['Merged?'] = 'No'
        matches << row.to_hash.map { |_key, value| value }
      end
    end

    CSV.open('merged.csv', 'wb') do |fcsv|
      matches.each { |match| fcsv << match }
    end
  end

  desc 'Imports Ryan\'s completed group list'
  task import: :environment do
    require 'csv'

    csv_dataset = File.read('import_dataset.csv')
    csv = CSV.parse(csv_dataset, headers: true)
    csv.each do |row|
      next if row['Link'].nil?

      group = Group.new

      group.name = row['Group Name']
      group.group_type = determine_group_type(row['Link'])

      group.create_info

      group.info.members = 0
      group.info.link = sanitize_link(row['Link'])
      group.info.is_regional = row['City/Region'] == 'Countrywide'

      group.create_location

      group.location.lat = row['Latitude']
      group.location.lon = row['Longitude']

      group.save
    end
  end

  def trim_link(link)
    matches = link.match(%r{(?:http:\/\/|https:\/\/)?(?:www\.)?(?:facebook.com|fb.com)\/(groups\/)?(.*)})

    return nil if matches.nil?

    trimmed_link = matches[2]
    trimmed_link = trimmed_link[0..-2] if trimmed_link[-1] == '/'
    trimmed_link
  end

  def sanitize_link(link)
    link.gsub!(%r{^www}, 'https://www');
    link.gsub!(%r{^(facebook|fb)}, 'https://www.\\1')
    link.gsub!(%r{^http:\/\/}, 'https://')
    link.gsub!("https://www.fb.com", "https://www.facebook.com")

    link
  end

  def determine_group_type(link)
    if is_group_link(link)
      return 'facebook group'
    elsif is_facebook_link(link)
      return 'facebook page'
    end

    'other'
  end

  def is_group_link(link)
    link.match(%r{.*\/groups\/.*}).nil?
  end

  def is_facebook_link(link)
    link.match(%{.*(?:facebook\.com|fb\.com).*})
  end
end
