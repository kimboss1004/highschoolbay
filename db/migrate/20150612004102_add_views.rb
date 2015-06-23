class AddViews < ActiveRecord::Migration
  def change
    add_column :questions, :views, :integer, :default => 0
    add_column :images, :views, :integer, :default => 0
  end
end
