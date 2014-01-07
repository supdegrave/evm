class AddFieldsToFunctions < ActiveRecord::Migration
  def change
    add_column :functions, :job_description, :string
    add_column :functions, :recruit_status, :string
    add_column :functions, :gdrive_folder, :string
  end
end

# id
# parent department
# name
# description
# link to job-description
# link to google-drive folder
# NOrg email
# Nr. of leads