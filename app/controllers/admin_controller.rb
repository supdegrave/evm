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
    role_name = user_params[:role_name]
    
    if user_params[:function_id].nil? # role only, no function (ie: admin, Board Member)
      user.grant role_name      
    else
      function = Function.find(user_params[:function_id]) 
      
      # is function-role already assigned?
      if !function.roles.find_by(name: role_name).nil? 
        user.errors.messages[:error] = "#{function.name} #{role_name} is already assigned to another user."
      # check if user is board member if adding 'Owner' role to a function 
      elsif ("Owner" == role_name && !user.is_board_member?) 
        user.errors.messages[:error] = "'Owner' role can only be assigned to a board member."
      end
      
      user.grant role_name, function if user.errors.messages.empty?
    end
    
    respond_to do |format|
      if user.has_role? role_name, function
        format.json { render json: user.functions_roles }
      else
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def org_chart
    @board = User.with_role "Board Member"
  end
  
  def edit_user
    @user = User.find(params[:id])
  end
  
  # TODO: Don't require password to edit account 
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
end