json.extract! client, :id, :Name, :Address, :BankAccount, :PaymentDelay, :created_at, :updated_at
json.url client_url(client, format: :json)
