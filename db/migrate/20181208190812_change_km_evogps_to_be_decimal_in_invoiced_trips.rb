class ChangeKmEvogpsToBeDecimalInInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
  	  	   change_column :invoiced_trips, :km_evogps, :decimal  
  end
end
