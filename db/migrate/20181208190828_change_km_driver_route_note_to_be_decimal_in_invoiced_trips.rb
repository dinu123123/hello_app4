class ChangeKmDriverRouteNoteToBeDecimalInInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
  	  	   change_column :invoiced_trips, :km_driver_route_note, :decimal   
  end
end
