json.extract! activity, :id, :date, :DRIVER_id, :truck_id, :trailer_id, :client_id, :driver_expense_id, :truck_expense_id, :start_address, :dest_addresses, :volume, :tank, :comments, :created_at, :updated_at
json.url activity_url(activity, format: :json)
