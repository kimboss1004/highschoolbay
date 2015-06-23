class CreateCategorable < ActiveRecord::Migration
  def change
    create_table :categorables do |t|
      t.integer :category_id
      t.string :categorable_type
      t.integer :categorable_id
    end
  end
end
