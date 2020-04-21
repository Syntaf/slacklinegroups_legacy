# frozen_string_literal: true

require 'fileutils'

namespace :dataset do
  desc 'Matches database against Ryan\'s larger dataset'
  task match: :environment do
    require 'csv'

    matches = []

    csv_dataset = File.read('merge_dataset.csv')
    csv = CSV.parse(csv_dataset, headers: true)
    csv.each do |row|
      link = trim_link(row['Link']) unless row['Link'].nil?

      groups = Group.joins(:info).where('info.link LIKE ?', "%#{link}%")

      groups.each { |group| puts group.info.link }
    end
  end

  def trim_link(link)
    matches = link.match(%r{(?:http:\/\/|https:\/\/)?www.facebook.com\/(groups\/)?(.*)})
    trimmed_link = matches[2]

    trimmed_link = trimmed_link[0..-2] if trimmed_link[-1] == '/'

    trimmed_link
  end
end
