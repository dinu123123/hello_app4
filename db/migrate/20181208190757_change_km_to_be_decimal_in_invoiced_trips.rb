class ChangeKmToBeDecimalInInvoicedTrips < ActiveRecord::Migration[5.1]

  def up
    change_column :invoiced_trips, :km, :decimal
  end

  def down
    change_column :invoiced_trips, :km, :integer
  end
end
