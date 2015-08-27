class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true, counter_cache: true
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:voteable_id, :voteable_type]

  after_create :inc_dec_counters, :user_inc_dec_counters, :notify_creator

  after_update :inc_dec_counters_update, :user_inc_dec_counters_update, :notify_creator

  private

  def inc_dec_counters
    if vote == true
      voteable.update(votes_count: (voteable.votes_count + 1))
    elsif vote == false
      voteable.update(votes_count: (voteable.votes_count - 1))
    end
  end

  def inc_dec_counters_update
    if voteable && vote == true
      voteable.update(votes_count: (voteable.votes_count + 2))
    elsif voteable && vote == false
      voteable.update(votes_count: (voteable.votes_count - 2))
    end
  end


  def user_inc_dec_counters
    if voteable.class != Question && voteable.votes_count < 50
      if voteable.user != user && vote == true && voteable.votes_count < 50
        voteable.user.update(votes_count: (voteable.user.votes_count + 2))
      elsif vote == false
        voteable.user.update(votes_count: (voteable.user.votes_count - 2))
      end
    end
  end

  def user_inc_dec_counters_update
    if voteable.class != Question
      if voteable.user != user && vote == true && voteable.votes_count < 50
        voteable.user.update(votes_count: (voteable.user.votes_count + 2))
      elsif voteable.user && vote == false
        voteable.user.update(votes_count: (voteable.user.votes_count - 2))
      end
    end
  end


  def notify_creator
    unless self.user == self.voteable.user
      Notification.create(reciever: self.voteable.user, sender_id: self.user.id, postable: self.voteable, notificable: self)
    end
  end

end