class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true, counter_cache: true
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:voteable_id, :voteable_type]

  after_create :inc_dec_counters
  after_update :inc_dec_counters_update

  after_create :user_inc_dec_counters
  after_update :user_inc_dec_counters_update

  private

  def inc_dec_counters
    if voteable && vote == true
      voteable.increment(:votes_count)
      voteable.save
    elsif voteable && vote == false
      voteable.decrement(:votes_count)
      voteable.save
    end
  end

  def inc_dec_counters_update
    if voteable && vote == true
      voteable.increment(:votes_count, 2)
      voteable.save
    elsif voteable && vote == false
      voteable.decrement(:votes_count, 2)
      voteable.save
    end
  end


  def user_inc_dec_counters
    if voteable.class != Question
      if user && vote == true
        user.increment(:votes_count, 1)
        user.save
      elsif user && vote == false
        user.decrement(:votes_count, 1)
        user.save
      end
    end
  end

  def user_inc_dec_counters_update
    if voteable.class != Question
      if user && vote == true
        user.increment(:votes_count, 2)
        user.save
      elsif user && vote == false
        user.decrement(:votes_count, 2)
        user.save
      end
    end
  end

end