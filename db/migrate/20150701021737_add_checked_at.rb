class AddCheckedAt < ActiveRecord::Migration
  def change
    add_column :notifications, :checked_at, :timestamp
  end
end
