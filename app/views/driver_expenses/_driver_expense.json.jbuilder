json.extract! driver_expense, :id, :DRIVER_id, :DATE, :AMOUNT, :INFO, :DESCRIPTION, :created_at, :updated_at
json.url driver_expense_url(driver_expense, format: :json)
