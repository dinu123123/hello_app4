class AddAmountToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :amount, :decimal
  end
end
