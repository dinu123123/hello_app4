class CreateBeTolls < ActiveRecord::Migration[5.1]
  def change
    create_table :be_tolls do |t|
      t.integer :record_number
      t.string :reference_number
      t.date :date_of_detailed_trip_statement
      t.string :identification_of_the_road_network_user
      t.date :bill_cycle_start_date
      t.date :bill_cycle_end_date
      t.string :obu_serial_number
      t.string :internal_obu_identifier
      t.string :country_code
      t.string :licence_plate_number
      t.string :euro_emission_class
      t.string :gross_combination_weight
      t.string :payment_method
      t.date :date_of_processing
      t.date :date_of_usage
      t.string :toll_charger
      t.string :road_type
      t.string :route
      t.time :entry_time
      t.decimal :charged_distance
      t.string :distance_unit
      t.decimal :charged_amount_excluding_vat
      t.string :currency
      t.string :vat_indicator

      t.integer :truck_id

      t.timestamps
    end
  end
end

