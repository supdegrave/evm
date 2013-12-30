class Function < ActiveRecord::Base
  resourcify
  after_create :set_email
  
  validates :name, uniqueness: { case_sensitive: false }
  
  # def leads 
  #   leads_roles = self.roles.reject { |role| !["Lead", "Co-Lead", "Mentor"].include? role.name }
  #   leads_roles.map { |role| role.users.first }
  # end
  
  def lead
    role_by_name "Lead"
  end

  def colead
    role_by_name "Co-Lead"
  end

  def mentor
    role_by_name "Mentor"
  end

  private 
    def role_by_name(name)
      User.with_role(name, self).first
    end

    def set_email
      name_for_email = self.name.parameterize('_')
      self.update_attribute :email, "#{name_for_email}@goingnowhere.org" 
    end
  
  # can't enforce uniqueness unless also validating presence 
  # validates :email, uniqueness: { case_sensitive: false }
end
