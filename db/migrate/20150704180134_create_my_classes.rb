class CreateMyClasses < ActiveRecord::Migration
  def change
    create_table :my_classes do |t|
      t.integer :user_id
      t.string :classable_type
      t.integer :classable_id
    end
  end
end
