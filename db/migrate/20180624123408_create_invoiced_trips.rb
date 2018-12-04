class CreateInvoicedTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :invoiced_trips do |t|
      t.date     :date
      t.date     :StartDate
      t.date     :EndDate
      t.integer  :invoice_id
      t.integer  :client_id
      t.integer  :DRIVER_id
      t.integer  :truck_id
      t.decimal  :germany_toll
      t.decimal  :belgium_toll
      t.decimal  :swiss_toll
      t.decimal  :france_toll
      t.decimal  :italy_toll
      t.decimal  :uk_toll
      t.decimal  :netherlands_toll
      t.integer  :km
      t.integer  :km_evogps
      t.integer  :km_driver_route_note
      t.decimal  :total_amount

      t.timestamps
    end
  end
end
