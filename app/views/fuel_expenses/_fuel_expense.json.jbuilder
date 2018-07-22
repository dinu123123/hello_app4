json.extract! fuel_expense, :id, :trstime, :TrsDate, :Product, :Volume, :NetAmount, :KmInsertion, :PlateNr, :CardNr, :StationName, :GrossUnitPrice, :GrossAmount, :Country, :created_at, :updated_at
json.url fuel_expense_url(fuel_expense, format: :json)
