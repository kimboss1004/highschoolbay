class DestroyTags < ActiveRecord::Migration
  def change
  	remove_column :images, :tag
  end
end
