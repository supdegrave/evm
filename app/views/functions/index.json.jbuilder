# Function(id: integer, name: string, email: string, created_at: datetime, updated_at: datetime, job_description: string, recruit_status: string, gdrive_folder: string)

# json.class_name "Functions"
# json.Functions @functions do |function|
json.array!(@functions) do |function|
  json.extract! function, :id, :name
  # json.url function_url(function, format: :json)
end
