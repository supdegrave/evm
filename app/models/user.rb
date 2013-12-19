class User < ActiveRecord::Base
  rolify
  
  devise  :invitable, 
          :database_authenticatable, 
          :registerable, 
          # :confirmable, 
          :recoverable, 
          :rememberable, 
          :trackable, 
          :validatable
          
  validates_presence_of :first_name, :last_name 
  
  def name 
    "#{first_name} #{last_name}"
  end
  
  def functions_roles
    self.roles.collect do |role|
      function = !role.resource_id.nil? && role.resource_type == "Function" ? Function.find(role.resource_id).name : nil
      {function: function , role: role.name}
    end
  end
end
