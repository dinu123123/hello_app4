class AddCollectionDateToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :collection_date, :date
  end
end
