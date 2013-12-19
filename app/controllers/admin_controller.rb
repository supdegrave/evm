class AdminController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    
    @users = User.all
    @roles = Role.all.delete_if { |role| !role.resource_type.nil? }
    @functions = Function.all
    
    @new_user = User.new
    @new_role = Role.new 
    @new_function = Function.new 
  end

  def invitation
    strong_params = params.require(:user).permit(:email, :first_name)
    temp_first_name = {first_name: params[:user][:email].split("@")[0]}
    @user = User.new(strong_params.merge(temp_first_name))
    
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

  def add_role
    user_params = params[:user]
    user = User.find(user_params[:user_id])
    
    if user_params[:function_id].nil? 
      user.grant user_params[:role_name]      
    else
      function = Function.find(user_params[:function_id])    
      user.grant user_params[:role_name], function
    end
    
    respond_to do |format|
      if user.has_role? user_params[:role_name], function
        format.json { render json: user.functions_roles }
      else
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # def edit_user
  #   @user = User.find(params[:id])
  #   puts "****************************"
  #   puts @user
  #   puts "****************************"
  # end
  
  # Don't require password to edit account 
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
end