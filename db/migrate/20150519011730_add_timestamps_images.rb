class AddTimestampsImages < ActiveRecord::Migration
  def change
    add_column :images, :created_at, :datetime
    add_column :images, :updated_at, :datetime
  end
end
