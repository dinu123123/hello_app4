json.extract! pricing, :id, :DATETIME, :CLIENT_id, :price_per_km, :price_per_day, :surcharge, :DESCRIPTION, :created_at, :updated_at
json.url pricing_url(pricing, format: :json)
