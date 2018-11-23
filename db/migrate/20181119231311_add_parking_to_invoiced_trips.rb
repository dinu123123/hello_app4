class AddParkingToInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :invoiced_trips, :parking, :decimal
  end
end
