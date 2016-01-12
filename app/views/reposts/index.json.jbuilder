json.array!(@reposts) do |repost|
  json.extract! repost, :id, :event_id
  json.url repost_url(repost, format: :json)
end
