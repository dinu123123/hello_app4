class AddBridgeToInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :invoiced_trips, :bridge, :decimal
  end
end
