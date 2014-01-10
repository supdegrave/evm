class UsersController < ApplicationController
  before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json {  }
    end
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save(validate: false)
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end
  
  def update
    # request.env["HTTP_REFERER"] = "/admin/edit/<user_id>" or "/users/<user_id>" 
    user = User.find(params[:id])
    # user_params = params[:user]
    # if user_params[:password].blank? 
    #   user_params.delete("password")
    #   user_params.delete("password_confirmation")
    #   user_params.delete("current_password")
    # end
    
    if user == current_user 
        current_user_update user
    elsif current_user.has_role? :admin
      admin_update user
    else 
      redirect_to home_path, message: 'Not authorized to edit user.'
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
  
  protected
  def current_user_update(user)
    clean_params
    strong_params = params.require(:user).permit(:first_name, :last_name, :email, :playa_name, :skype_id, :emergency_contact, :emergency_contact_relation, :emergency_contact_phone, :emergency_contact_email, :medical_concerns)
    
    if user.update_attributes(strong_params)
      redirect_to user_path(user), :notice => "User updated."
    else
      redirect_to user_path(user), :alert => "Unable to update user."
    end 
  end
  
  def admin_update(user)
    clean_params
    strong_params = params.require(:user).permit(:email, :first_name, :last_name)
  
    if user.update_attributes(strong_params)
      redirect_to admin_path, :notice => "User updated."
    else
      redirect_to admin_path, :alert => "Unable to update user."
    end
  end
  
  def clean_params
    user_params = params[:user]
    if user_params[:password].blank? 
      user_params.delete("password")
      user_params.delete("password_confirmation")
      user_params.delete("current_password")
    end
  end
end