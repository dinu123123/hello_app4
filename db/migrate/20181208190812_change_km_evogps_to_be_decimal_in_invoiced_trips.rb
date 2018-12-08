class ChangeKmEvogpsToBeDecimalInInvoicedTrips < ActiveRecord::Migration[5.1]
  
  def up
    change_column :invoiced_trips, :km_evogps, :decimal
  end

  def down
    change_column :invoiced_trips, :km_evogps, :integer
  end

end
