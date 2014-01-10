# User(
#   id: integer, 
#   email: string, 
#   encrypted_password: string, 
#   reset_password_token: string, 
#   reset_password_sent_at: datetime, 
#   remember_created_at: datetime, 
#   sign_in_count: integer, 
#   current_sign_in_at: datetime, 
#   last_sign_in_at: datetime, 
#   current_sign_in_ip: string, 
#   last_sign_in_ip: string, 
#   created_at: datetime, 
#   updated_at: datetime, 
#   confirmation_token: string, 
#   confirmed_at: datetime, 
#   confirmation_sent_at: datetime, 
#   unconfirmed_email: string, 
#   invitation_token: string, 
#   invitation_created_at: datetime, 
#   invitation_sent_at: datetime, 
#   invitation_accepted_at: datetime, 
#   invitation_limit: integer, 
#   invited_by_id: integer, 
#   invited_by_type: string, 
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
  json.extract! user, :id, :name, :first_name, :last_name, :email, :skype_id
  # json.url user_url(user, format: :json)
end
