class CreateGategories < ActiveRecord::Migration
  def change
    create_table :gategories do |t|
      t.string :name
      t.integer :master_id
      t.integer :group_id
    end
  end
end
