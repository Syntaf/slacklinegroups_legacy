class MultipleLinks < ActiveRecord::Migration[5.1]
  def change
    rename_column :groups, :link, :fb_group
    add_column :groups, :fb_page, :string
    add_column :groups, :website, :string
  end
end
