class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :group_id
    end
  end
end
