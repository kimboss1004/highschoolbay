class User < ActiveRecord::Base
  has_many :questions
  has_many :images
  has_many :comments
  has_many :votes
  belongs_to :group

  has_secure_password

  validates :username, presence: true, uniqueness: true
end