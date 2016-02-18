json.array!(@conversations) do |conversation|
  json.extract! conversation, :id, :name, :salt
  json.url conversation_url(conversation, format: :json)
end
