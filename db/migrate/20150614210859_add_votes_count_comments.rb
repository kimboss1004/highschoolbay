class AddVotesCountComments < ActiveRecord::Migration
  def change
    add_column :comments, :votes_count, :integer, :default => 0
  end

Comment.find_each { |comment| Comment.reset_counters(comment.id, :votes) }
end
