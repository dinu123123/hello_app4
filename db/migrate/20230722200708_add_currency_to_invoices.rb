class AddCurrencyToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :currency_id, :integer
  end
end
