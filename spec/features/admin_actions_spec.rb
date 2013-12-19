require 'spec_helper'

describe "Admin" do
  # it "logs in using selenium driver", :js => true do
  #   @admin = FactoryGirl.create(:admin)
  #   visit root_path
  #   click_link "Login"
  #   fill_in "user_email", :with => @admin.email
  #   fill_in "user_password", :with => @admin.password
  #   click_button "Sign in"
  #   click_link "Admin"
  # end

  before(:each) do
    @admin = FactoryGirl.create(:admin)
    visit root_path
    click_link "Login"
    fill_in "Email", :with => @admin.email
    fill_in "Password", :with => @admin.password
    click_button "Sign in"
    click_link "Admin" 
  end
  
  it "page shows Admin in user list" do
    page.should have_content @admin.name
    page.should have_content "Admin"
    page.should have_content "Users"
    page.should have_content "Roles"
  end
  
  # it "adds a new user" do
  #   @user = FactoryGirl.build(:user)
  # 
  #   fill_in "First name", :with => new_user.first_name
  #   fill_in "Last name", :with => new_user.last_name
  #   fill_in "Email", :with => new_user.email
  #   click_button "Add User"
  # 
  #   click_link "Admin"
  # 
  #   page.should have_content new_user.name
  # end
  
  it "page shows existing roles" do
    page.should have_content "Roles"
    page.should have_content "admin"
  end

  # 
  # commented out to avoid selenium forcing browser window to open with every change
  # TODO: look into webkit driver rather than selenium 
  #   
  # it "adds a new role", :js => true do
  #   role = FactoryGirl.create(:role)
  #   fill_in "role_name", :with => role.name 
  #   click_button "Add Role" 
  #   page.should have_content role.name 
  #   # TODO: figure out why ajax update isn't working in selenium 
  # end

  # it "adds a new function" do
  # end

  # it "assigns role to user" do
  #   
  # end

  # it "assigns function to user" do
  #   
  # end
end



# Internal Server Error
# SQLite3::BusyException: database is locked: INSERT INTO "users" ("confirmation_sent_at", "confirmation_token", "created_at", "email", "encrypted_password", "first_name", "last_name", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?, ?)
# WEBrick/1.3.1 (Ruby/2.0.0/2013-05-14) at 127.0.0.1:64366
