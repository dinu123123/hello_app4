json.extract! card, :id, :provider, :name, :card_id, :pin, :start_date, :end_date, :created_at, :updated_at
json.url card_url(card, format: :json)
