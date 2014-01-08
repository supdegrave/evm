class Function < ActiveRecord::Base
  resourcify
  after_create :set_email
  
  validates :name, uniqueness: { case_sensitive: false }
  
  def lead
    user_by_role "Lead"
  end

  def colead
    user_by_role "Co-Lead"
  end

  def mentor
    user_by_role "Mentor"
  end

  private 
    def user_by_role(name)
      User.with_role(name, self).first
    end

    def set_email
      name_for_email = self.name.parameterize('_')
      self.update_attribute :email, "#{name_for_email}@goingnowhere.org" 
    end
end
