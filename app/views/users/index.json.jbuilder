# User(
#   id: integer, 
#   email: string, 
#   ... lots of devise properties elided ... 
#   first_name: string, 
#   last_name: string, 
#   playa_name: string, 
#   skype_id: string, 
#   emergency_contact: string, 
#   emergency_contact_relation: string, 
#   emergency_contact_phone: string, 
#   emergency_contact_email: string, 
#   medical_concerns: string
# )


json.array!(@users) do |user|
  json.extract! user, :id, :name, :first_name, :last_name, :email, :skype_id, :functions_roles
  # json.url user_url(user, format: :json)
end
