class CreateDb < ActiveRecord::Migration[5.1]
  def change
    create_table :group do |t|
      t.string  :name
      t.string  :group_type
      t.integer :location_id
      t.integer :info_id
    end

    create_table :location do |t|
      t.decimal :lat
      t.decimal :lon
    end

    create_table :info do |t|
      t.string  :link
      t.integer :members
      t.boolean :is_regional
    end

    create_table :submitted_group do |t|
      t.string    :name
      t.string    :type
      t.decimal   :lat
      t.decimal   :lon
      t.string    :link
      t.integer   :members
      t.boolean   :is_regional
    end

    create_table :submitted_group_history do |t|
      t.string    :name
      t.string    :type
      t.decimal   :lat
      t.decimal   :lon
      t.string    :link
      t.integer   :members
      t.boolean   :is_regional
      t.timestamp :verified_time
    end
  end
end
