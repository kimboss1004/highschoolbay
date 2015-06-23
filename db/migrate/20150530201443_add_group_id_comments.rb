class AddGroupIdComments < ActiveRecord::Migration
  def change
    add_column :comments, :group_id, :integer
  end
end
