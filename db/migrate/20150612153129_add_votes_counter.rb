class AddVotesCounter < ActiveRecord::Migration
  def change
    add_column :questions, :votes_count, :integer, :default => 0
    add_column :images, :votes_count, :integer, :default => 0
  end

Question.find_each { |question| Question.reset_counters(question.id, :votes) }
Image.find_each { |image| Image.reset_counters(image.id, :votes) }



end
