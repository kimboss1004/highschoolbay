class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :votes, as: :voteable

  has_many :notifications, as: :postable, :dependent => :destroy

  after_create :notify_creator, :notify_commentors

  validates :body, presence: true

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end
 
  def total_votes
    up_votes - down_votes
  end
  
  def notify_commentors
    commentors = self.commentable.commentors.uniq.reject {|user| user == self.user }.reject {|user| user == self.commentable.user }
    commentors.each do |commentor| 
      Notification.create(reciever: commentor, sender_id: self.user.id, postable: self.commentable, notificable: self)
    end
  end

  def notify_creator
    unless self.user == self.commentable.user
      Notification.create(reciever: self.commentable.user, sender_id: self.user.id, postable: self.commentable, notificable: self)
    end
  end


end