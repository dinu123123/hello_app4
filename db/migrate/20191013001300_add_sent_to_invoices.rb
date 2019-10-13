class AddSentToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :sent, :boolean, default: false
  end
end
