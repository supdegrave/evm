# Role(id: integer, name: string, resource_id: integer, resource_type: string, created_at: datetime, updated_at: datetime)

json.array!(@roles) do |role|
  json.extract! role, :id, :name 
  # json.url role_url(role, format: :json)
end
