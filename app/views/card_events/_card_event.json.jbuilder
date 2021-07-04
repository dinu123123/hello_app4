json.extract! card_event, :id, :date, :truck_id, :card_id, :created_at, :updated_at
json.url card_event_url(card_event, format: :json)
