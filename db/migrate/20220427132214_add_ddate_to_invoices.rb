class AddDdateToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :ddate, :date
  end
end
