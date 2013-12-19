class Function < ActiveRecord::Base
  resourcify
  
  validates :name, uniqueness: { case_sensitive: false }
  
  # can't enforce uniqueness unless also validating presence 
  # validates :email, uniqueness: { case_sensitive: false }
end
