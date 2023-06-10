class AddDispatcherIdToInvoicedTrip < ActiveRecord::Migration[5.2]
  def change
    add_column :invoiced_trips, :dispatcher_id, :integer
  end
end
