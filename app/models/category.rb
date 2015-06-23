class Category < ActiveRecord::Base
  has_many :sub_categories, class_name: 'Category', foreign_key: 'master_id', :dependent => :destroy
  belongs_to :master, class_name: 'Category', foreign_key: 'master_id'

  has_many :categorables, :dependent => :destroy
  has_many :questions, through: :categorables, source: :categorable, source_type: "Question"
  has_many :images, through: :categorables, source: :categorable, source_type: "Image"

  has_many :gategories, class_name: "Gategory", foreign_key: "master_id", :dependent => :destroy

  validates :name, presence: true, uniqueness: true


 def ancestor_objects
    masters = []
    category_copy = self
    loop do
      masters.insert(0,category_copy)
      break if category_copy.master.nil? 
      category_copy = category_copy.master
    end
    return masters
 end

 def descendents
  total_descendents = []
  next_generation = children([self])
  total_descendents << next_generation
  while next_generation.any?
    next_generation = children(next_generation)
    total_descendents << next_generation
  end
  return total_descendents.flatten!
 end


 private

 def children(next_generation)
  output = []
  next_generation.each do |individual|
    output << individual.sub_categories      
  end
  return output.flatten!
 end



end