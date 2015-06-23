class Categorable < ActiveRecord::Base

  belongs_to :categorable, polymorphic: true
  belongs_to :category 

end