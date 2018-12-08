class ChangeKmDriverRouteNoteToBeDecimalInInvoicedTrips < ActiveRecord::Migration[5.1]
  def up
    change_column :invoiced_trips, :km_driver_route_note, :decimal
  end

  def down
    change_column :invoiced_trips, :km_driver_route_note, :integer
  end



end
