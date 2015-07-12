class User < ActiveRecord::Base
  has_many :questions, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :votes
  has_many :notifications, class_name: 'Notification', foreign_key: 'reciever_id', :dependent => :destroy
  has_many :classes, class_name: 'MyClass', foreign_key: 'user_id', :dependent => :destroy
  belongs_to :group

  has_secure_password

  validates :username, presence: true, uniqueness: true, length: { maximum: 26 }
  validates :password, length: { maximum: 20 }


 def unchecked_notifications
  total = self.notifications.where(checked: nil).size
  unless total == 0
    return total
  end
 end


end