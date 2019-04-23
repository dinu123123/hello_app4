class CreateAs24GermanyTolls < ActiveRecord::Migration[5.2]
  def change
    create_table :as24_germany_tolls do |t|
      t.string :contract
      t.integer :vehicle_card
      t.string :driver_card
      t.string :product_code
      t.string :product
      t.decimal :volume
      t.date :date
      t.time :time
      t.string :country
      t.string :site_nbr
      t.string :station
      t.date :invoice_date
      t.integer :invoice_nbr
      t.decimal :vat_rate
      t.string :transation_currency
      t.decimal :transaction_excl_vat
      t.decimal :transaction_vat
      t.decimal :transaction_incl_vat
      t.string :payment_currency
      t.decimal :payment_excl_vat
      t.decimal :miles
      t.string :immatriculation
      t.string :document_type

      t.timestamps
    end
  end
end
