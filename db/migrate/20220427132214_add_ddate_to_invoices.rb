class AddDdateToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :ddate, :date, :default => '01/01/2000'
  end
end
