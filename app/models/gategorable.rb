class Gategorable < ActiveRecord::Base
  belongs_to :gategory
  belongs_to :gategorable, polymorphic: true
  belongs_to :group


end