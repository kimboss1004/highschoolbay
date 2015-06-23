class Group < ActiveRecord::Base
  has_many :questions
  has_many :images
  has_many :comments
  has_many :gategories, :dependent => :destroy
  has_many :users

  validates :school, presence: true, length: { maximum: 30 }
  validates_uniqueness_of :school, scope: [:state, :city]
  validates :state, presence: true
  validates :city, presence: true


  searchable do
    text :school, :boost => 3.0
    text :city
    text :state
  end
end