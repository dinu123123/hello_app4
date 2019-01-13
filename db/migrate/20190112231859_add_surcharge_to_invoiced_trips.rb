class AddSurchargeToInvoicedTrips < ActiveRecord::Migration[5.2]
  def change
    add_column :invoiced_trips, :surcharge, :decimal
  end
end
