class CreatePricings < ActiveRecord::Migration[5.2]
  def change
    create_table :pricings do |t|
      t.datetime :DATETIME
      t.integer :client_id
      t.decimal :price_per_km
      t.decimal :price_per_day
      t.decimal :surcharge
      t.text :DESCRIPTION

      t.timestamps
    end
  end
end
