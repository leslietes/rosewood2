class Setting < ActiveRecord::Base
  has_attached_file :photo1, :styles => {:large => "940x360#", :small => "120x90#" }
  has_attached_file :photo2, :styles => {:large => "940x360#", :small => "120x90#" }
  has_attached_file :photo3, :styles => {:large => "940x360#", :small => "120x90#" }
  has_attached_file :photo4, :styles => {:large => "940x360#", :small => "120x90#" }
  has_attached_file :photo5, :styles => {:large => "940x360#", :small => "120x90#" }
  
  validates_attachment_content_type :photo1, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
  validates_attachment_content_type :photo2, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
  validates_attachment_content_type :photo3, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
  validates_attachment_content_type :photo4, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
  validates_attachment_content_type :photo5, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
        
  has_attached_file :whyus1, :styles => {:thumb => "64x64#"}
  has_attached_file :whyus2, :styles => {:thumb => "64x64#"}
  has_attached_file :whyus3, :styles => {:thumb => "64x64#"}
  
  validates_attachment_content_type :whyus1, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
  validates_attachment_content_type :whyus2, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
  validates_attachment_content_type :whyus3, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
      
end
