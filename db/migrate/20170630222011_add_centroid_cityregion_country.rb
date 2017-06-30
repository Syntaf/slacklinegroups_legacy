class AddCentroidCityregionCountry < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :centroid_lat, :decimal
    add_column :groups, :centroid_lon, :decimal
    add_column :groups, :order, :string
    add_column :groups, :country, :string
  end
end
