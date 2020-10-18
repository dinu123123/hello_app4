class AddInvoicedTripIdToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :invoiced_trip_id, :integer
  end
end
