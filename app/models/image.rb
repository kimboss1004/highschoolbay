class Image < ActiveRecord::Base
  is_impressionable :counter_cache => true, :column_name => :views, :unique => :request_hash
  is_impressionable :counter_cache => true, :column_name => :views, :unique => :all

  belongs_to :user
  belongs_to :group

  has_many :categorables, as: :categorable, :dependent => :destroy
  has_many :categories, through: :categorables

  has_many :gategorables, as: :gategorable, :dependent => :destroy
  has_many :gategories, through: :gategorables

  has_many :pictures, :dependent => :destroy

  has_many :comments, as: :commentable, :dependent => :destroy
  has_many :commentors, through: :comments, source: :user
  
  has_many :votes, as: :voteable, :dependent => :destroy

  has_many :notifications, as: :postable, :dependent => :destroy

  validates :title, presence: true, length: { maximum: 200 }
  validates :categories, presence: true

  searchable do
    text :title, :boost => 3.0
    text :description, :boost => 2.0
    text :tag, :boost => 2.0
    text :comments do
      comments.map(&:body)
    end
    integer :category_ids, :multiple => true
    integer :gategory_ids, multiple: true
    integer :group_id
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def total_votes
    up_votes - down_votes
  end

end