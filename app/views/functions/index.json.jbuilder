json.array!(@functions) do |function|
  json.extract! function, :id
  json.url function_url(function, format: :json)
end
