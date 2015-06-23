class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
  end
end
