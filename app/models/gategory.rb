class Gategory < ActiveRecord::Base
  belongs_to :master, class_name: "Category", foreign_key: "master_id"
  belongs_to :gmaster, class_name: "Gategory", foreign_key: "gmaster_id"
  has_many :sub_gategories, class_name: 'Gategory', foreign_key: 'gmaster_id', :dependent => :destroy

  belongs_to :group

  has_many :gategorables, :dependent => :destroy
  has_many :questions, through: :gategorables, source: :gategorable, source_type: "Question"
  has_many :images, through: :gategorables, source: :gategorable, source_type: "Image"

  validates_uniqueness_of :name, scope: :group_id
  validates :name, presence: true, length: { maximum: 30 }


 def ancestor_gategories
    masters = []
    gategory_copy = self
    loop do
      masters.insert(0,gategory_copy)
      break if gategory_copy.gmaster.nil? 
      gategory_copy = gategory_copy.gmaster
    end
    return masters
 end

 def master_category
    gategory_copy = self
    while gategory_copy.master.nil? 
      gategory_copy = gategory_copy.gmaster
    end
    return gategory_copy.master
 end

  def master_categories
    a = master_category
    master_categories = []
    master_categories << a
    while(a.master)
      a = a.master
      master_categories << a
    end
    return master_categories.reverse
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

 def gategory_descendents
   
 end



 private

 def children(next_generation)
  output = []
  next_generation.each do |individual|
    output << individual.sub_gategories      
  end
  return output.flatten!
 end         

end