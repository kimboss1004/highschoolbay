class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :postable_type
      t.integer :postable_id
      t.integer :reciever_id
      t.integer :sender_id
      t.string :notificable_type
      t.integer :notificable_id
      t.boolean :checked
      t.timestamps
    end
  end
end
