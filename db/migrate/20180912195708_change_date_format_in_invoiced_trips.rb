class ChangeDateFormatInInvoicedTrips < ActiveRecord::Migration[5.1]
  def up
    change_column :invoiced_trips, :StartDate, :datetime
    change_column :invoiced_trips, :EndDate,   :datetime
  end

  def down
    change_column :invoiced_trips, :StartDate, :date
    change_column :invoiced_trips, :EndDate,   :date
  end
end
