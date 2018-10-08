json.extract! invoice, :id, :name, :info, :date, :client_id, :vat, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
