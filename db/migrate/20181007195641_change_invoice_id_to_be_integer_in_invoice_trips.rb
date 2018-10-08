class ChangeInvoiceIdToBeIntegerInInvoiceTrips < ActiveRecord::Migration[5.1]
  def change
   def up
    change_column :invoiced_trips, :invoice_id, :integer
   end

   def down
    change_column :invoiced_trips, :invoice_id, :string
   end
  end
end
