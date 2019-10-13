class AddPrintedToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :printed, :boolean, default: false
  end
end
