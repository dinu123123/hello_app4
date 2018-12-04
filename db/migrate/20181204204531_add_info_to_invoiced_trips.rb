class AddInfoToInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :invoiced_trips, :info, :string
  end
end
