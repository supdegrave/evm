class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :playa_name, :string
    add_column :users, :skype_id, :string
    
    # emergency contact info
    add_column :users, :emergency_contact, :string
    add_column :users, :emergency_contact_relation, :string
    add_column :users, :emergency_contact_phone, :string
    add_column :users, :emergency_contact_email, :string
    
    # medical
    add_column :users, :medical_concerns, :string
  end
end

# https://docs.google.com/a/updegrave.com/document/d/1tp0sGx7e7X-PYKchQMBHr5WBMU_WGhKg2RgiBcN-4I4/edit#
# For volunteer registration, I would like to see:
# - Registration of personal details 
  # address/phone (optional), 
  # Skype ID (optional for non-leads), 
  # real name, 
  # playa name, 
  # emergency contact details (name, relation, phone))
# - Text field for medical stuff we should be aware of.
# - Skills (editable table. Skills should have a description/explanation, including skill levels. Gender should go under skills for shift scheduling. Skill levels should include descriptions, so that people can indicate what their skill level is based on definitions we give them. This can also be handy for the gender ‘skill’, because what we really want to know is, for example: is someone masculine enough to impress drunken locals, feminine enough to make them go away quietly, etc.)
# - Dietary restrictions (editable table; I would like to limit the available options, with some way for people to send email to the volunteer feeders to indicate the more esoteric restrictions)