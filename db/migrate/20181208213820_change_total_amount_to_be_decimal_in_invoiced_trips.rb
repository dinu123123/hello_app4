class ChangeTotalAmountToBeDecimalInInvoicedTrips < ActiveRecord::Migration[5.1]
  
  def up
    change_column :invoiced_trips, :total_amount, :decimal
  end

  def down
    change_column :invoiced_trips, :total_amount, :integer
  end


end
