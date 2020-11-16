class AddShippingToInvoicedTrip < ActiveRecord::Migration[5.2]
  def change
    add_column :invoiced_trips, :shipping, :string
  end
end
