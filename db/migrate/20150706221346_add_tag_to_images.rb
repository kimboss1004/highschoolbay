class AddTagToImages < ActiveRecord::Migration
  def change
    add_column :images, :tag, :text
  end
end
