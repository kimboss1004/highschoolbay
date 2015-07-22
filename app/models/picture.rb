class Picture < ActiveRecord::Base
  belongs_to :image, :dependent => :destroy

  has_attached_file :photo,
    :styles => { :small => "300x300>", :large => "1100x1500" },
  :url => "/images/products/:id/:style/:basename.:extension",
  :path => ":rails_root/public/images/products/:id/:style/:basename.:extension"

  do_not_validate_attachment_file_type :photo
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
end