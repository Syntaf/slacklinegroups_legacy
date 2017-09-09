class CreateUserSubmittedGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :user_submitted_groups do |t|
      t.text :cords
      t.string :name
      t.integer :members
      t.decimal :centroid_lat
      t.decimal :centroid_lon
      t.string :order
      t.string :country
      t.string :fb_group
      t.string :fb_page
      t.string :website
      t.string :email
      t.boolean :isRegional, default: false

      t.timestamps
    end
  end
end
