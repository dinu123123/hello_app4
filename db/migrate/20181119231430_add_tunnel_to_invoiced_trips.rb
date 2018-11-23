class AddTunnelToInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :invoiced_trips, :tunnel, :decimal
  end
end
