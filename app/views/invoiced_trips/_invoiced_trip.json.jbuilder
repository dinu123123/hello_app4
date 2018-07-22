json.extract! invoiced_trip, :id, :client_id, :DRIVER_id, :truck_id, :germany_toll, :belgium_toll, :swiss_toll, :france_toll, :italy_toll, :uk_toll, :netherlands_toll, :km, :total_amount, :created_at, :updated_at
json.url invoiced_trip_url(invoiced_trip, format: :json)
