class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.text :cords
      t.string :name
      t.integer :members

      t.timestamps
    end
  end
end
