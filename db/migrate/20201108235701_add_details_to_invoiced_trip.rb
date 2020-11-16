class AddDetailsToInvoicedTrip < ActiveRecord::Migration[5.2]
  def change
    add_column :invoiced_trips, :brand, :string
    add_column :invoiced_trips, :model, :string
    add_column :invoiced_trips, :vin, :string
    add_column :invoiced_trips, :production_year, :integer
    add_column :invoiced_trips, :km_usage, :integer
  end
end
