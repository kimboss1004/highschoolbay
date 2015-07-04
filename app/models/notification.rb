class Notification < ActiveRecord::Base

  belongs_to :postable, polymorphic: true
  belongs_to :notificable, polymorphic: true
  belongs_to :reciever, class_name: 'User', foreign_key: 'reciever_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'


  def self.old
    self.where('checked_at < ?', 2.days.ago)
  end
end