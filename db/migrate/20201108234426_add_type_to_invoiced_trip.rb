class AddTypeToInvoicedTrip < ActiveRecord::Migration[5.2]
  def change
    add_column :invoiced_trips, :typeT, :integer
  end
end
