class CreateDb < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string  :name
      t.string  :group_type
      
      t.timestamps
    end

    create_table :location do |t|
      t.belongs_to :group, index: true
      t.decimal :lat
      t.decimal :lon

      t.timestamps
    end

    create_table :info do |t|
      t.belongs_to :group, index: true
      t.string  :link
      t.integer :members
      t.boolean :is_regional

      t.timestamps
    end

    create_table :submitted_group do |t|
      t.string    :name
      t.string    :type
      t.decimal   :lat
      t.decimal   :lon
      t.string    :link
      t.integer   :members
      t.boolean   :is_regional

      t.timestamps
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

      t.timestamps
    end
  end
end
