class AddTrailerCostToInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :invoiced_trips, :trailer_cost, :decimal
  end
end
