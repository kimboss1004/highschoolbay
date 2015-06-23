class CreateGategorable < ActiveRecord::Migration
  def change
    create_table :gategorables do |t|
      t.integer :gategory_id
      t.string :gategorable_type
      t.integer :gategorable_id
    end
  end
end
