class AddApprovalFieldToUserSubmittedGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :user_submitted_groups, :approved, :integer, default: 0
  end
end
