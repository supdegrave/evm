# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

puts 'ROLES'
YAML.load(ENV['CORE_ROLES']).each do |role|
  Role.create(name: role, is_functional: false) if Role.find_by(name: role).nil? 
  puts 'role: ' << role
end

YAML.load(ENV['FUNCTIONAL_ROLES']).each do |role|
  Role.find_or_create_by_name(role)
  puts 'role: ' << role
end

# puts 'DEFAULT USERS'
# user = User.find_or_create_by_email :first_name => ENV['ADMIN_FIRST_NAME'].dup, 
#                                     :last_name => ENV['ADMIN_LAST_NAME'].dup, 
#                                     :email => ENV['ADMIN_EMAIL'].dup, 
#                                     :password => ENV['ADMIN_PASSWORD'].dup, 
#                                     :password_confirmation => ENV['ADMIN_PASSWORD'].dup
# puts 'user: ' << user.name
# user.confirm!
# user.add_role :admin
