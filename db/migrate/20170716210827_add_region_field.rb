class AddRegionField < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :isRegional, :boolean, default: false
  end
end
