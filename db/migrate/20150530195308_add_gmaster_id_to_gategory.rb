class AddGmasterIdToGategory < ActiveRecord::Migration
  def change
    add_column :gategories, :gmaster_id, :integer
  end
end
