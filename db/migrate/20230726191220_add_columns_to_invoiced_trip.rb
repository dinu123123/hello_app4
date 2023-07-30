class AddColumnsToInvoicedTrip < ActiveRecord::Migration[5.2]
  def change
    add_column :invoiced_trips, :amount, :decimal
    add_column :invoiced_trips, :currency_id, :integer
  end
end
