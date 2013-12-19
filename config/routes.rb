# TODO: it would be deeply useful to grok this completely: 
# http://guides.rubyonrails.org/routing.html

EventVolunteerManager::Application.routes.draw do
  devise_for :users
  resources :users, :roles, :functions
  
  # TODO: resourcify admin routes. I think that means changing #invitation to #create 
  get "/admin", to: "admin#index"
  post "/admin", to: "admin#invitation"
  get "/admin/edit/:id", to: "admin#edit_user", as: 'admin_edit'
  post "/admin/add_role", to: "admin#add_role"
  
  put "/users/:id", to: "users#update"
  
  root to: "home#index"
end

# accept_user_invitation_path  GET   /users/invitation/accept(.:format)  devise/invitations#edit
# remove_user_invitation_path  GET   /users/invitation/remove(.:format)  devise/invitations#destroy
# user_invitation_path   POST  /users/invitation(.:format)   devise/invitations#create
# new_user_invitation_path   GET   /users/invitation/new(.:format)   devise/invitations#new


# * :path => allows you to setup path name that will be used, as rails routes does.
#   The following route configuration would setup your route as /accounts instead of /users:
# 
#     devise_for :users, :path => 'accounts'
# 
# * :path_names => configure different path names to overwrite defaults :sign_in, :sign_out, :sign_up,
#   :password, :confirmation, :unlock.
# 
#     devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout',
#       :password => 'secret', :confirmation => 'verification', registration: 'register }
# 
# * :controllers => the controller which should be used. All routes by default points to Devise controllers.
#   However, if you want them to point to custom controller, you should do:
# 
#     devise_for :users, :controllers => { :sessions => "users/sessions" }
# 
# * :skip => tell which controller you want to skip routes from being created:
# 
#     devise_for :users, :skip => :sessions
# 
# * :only => the opposite of :skip, tell which controllers only to generate routes to:
# 
#     devise_for :users, :only => :sessions
# 
# * :skip_helpers => skip generating Devise url helpers like new_session_path(@user).
#   This is useful to avoid conflicts with previous routes and is false by default.
#   It accepts true as option, meaning it will skip all the helpers for the controllers
#   given in :skip but it also accepts specific helpers to be skipped:
# 
#     devise_for :users, :skip => [:registrations, :confirmations], :skip_helpers => true
#     devise_for :users, :skip_helpers => [:registrations, :confirmations]
# 
# * :constraints => works the same as Rails' constraints
# 
# * :defaults => works the same as Rails' defaults
