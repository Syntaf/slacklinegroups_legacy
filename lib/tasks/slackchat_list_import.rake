namespace :csv_importing do
  desc "Takes a CSV file formatted by NirAvneyons, and creates database entries"
  task import: :environment do
    require 'csv'

    csv_text = File.read('dataimport.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Group.create!(row.to_hash)
    end
  end

end
