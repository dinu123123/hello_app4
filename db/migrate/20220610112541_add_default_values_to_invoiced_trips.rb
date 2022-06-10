class AddDefaultValuesToInvoicedTrips < ActiveRecord::Migration[5.2]
  def change
  	change_column_default :invoiced_trips, :germany_toll, from: nil, to: 0
  	change_column_default :invoiced_trips, :belgium_toll, from: nil, to: 0
   	change_column_default :invoiced_trips, :swiss_toll, from: nil, to: 0   	
  	change_column_default :invoiced_trips, :france_toll, from: nil, to: 0
   	change_column_default :invoiced_trips, :italy_toll, from: nil, to: 0
  	change_column_default :invoiced_trips, :uk_toll, from: nil, to: 0
   	change_column_default :invoiced_trips, :netherlands_toll, from: nil, to: 0
  	change_column_default :invoiced_trips, :trailer_cost, from: nil, to: 0
   	change_column_default :invoiced_trips, :bridge, from: nil, to: 0
  	change_column_default :invoiced_trips, :parking, from: nil, to: 0
   	change_column_default :invoiced_trips, :tunnel, from: nil, to: 0

  end
end
