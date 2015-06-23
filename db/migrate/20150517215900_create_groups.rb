class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :school
      t.string :state
      t.string :city
    end
  end
end
