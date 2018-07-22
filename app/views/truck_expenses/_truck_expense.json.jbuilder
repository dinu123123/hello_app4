json.extract! truck_expense, :id, :truck_id, :DATE, :AMOUNT, :INFO, :DESCRIPTION, :created_at, :updated_at
json.url truck_expense_url(truck_expense, format: :json)
