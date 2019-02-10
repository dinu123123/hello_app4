class AddPricePerKmToInvoicedTrips < ActiveRecord::Migration[5.2]
  def change
    add_column :invoiced_trips, :price_per_km, :decimal
  end
end
