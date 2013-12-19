class UsersController < ApplicationController
  before_filter :authenticate_user!

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
  
  # admin update path - regular user path is via devise registrations 
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'

    user_params = params[:user]
    if user_params[:password].blank? 
      user_params.delete("password")
      user_params.delete("password_confirmation")
      user_params.delete("current_password")
    end

    strong_params = params.require(:user).permit(:email, :first_name, :last_name)

    user = User.find(params[:id])
    if user.update_attributes(strong_params)
      redirect_to admin_path, :notice => "User updated."
    else
      redirect_to admin_path, :alert => "Unable to update user."
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
end