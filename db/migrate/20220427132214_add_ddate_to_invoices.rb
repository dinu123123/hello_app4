class AddDdateToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :ddate, :date, :default => '2000-01-01 09:46:33'
  end
end
