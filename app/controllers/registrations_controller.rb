class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?
  
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :playa_name, :skype_id, :emergency_contact, :emergency_contact_relation, :emergency_contact_phone, :emergency_contact_email, :medical_concerns)}
  end
end
