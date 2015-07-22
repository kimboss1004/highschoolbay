class MyClass < ActiveRecord::Base
  belongs_to :user
  belongs_to :classable, polymorphic: true
  
  validates :classable_type, presence: true
  validates :classable_id, presence: true
  validates_uniqueness_of :user_id, scope: [:classable_type, :classable_id]


end