class ChangeKmToBeDecimalInInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
  	   change_column :invoiced_trips, :km, :decimal   
  end
end
