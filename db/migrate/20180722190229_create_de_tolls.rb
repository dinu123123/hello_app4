class CreateDeTolls < ActiveRecord::Migration[5.1]
  def change
    create_table :de_tolls do |t|
      t.string :platenr
      t.date :date
      t.time :time
      t.string :bookingid
      t.integer :art
      t.string :road
      t.string :via
      t.string :departure
      t.integer :costcentre
      t.integer :tariffmodel
      t.integer :axelclass
      t.integer :weightclass
      t.integer :emissioncat
      t.integer :roadoperators
      t.string :ver
      t.decimal :km
      t.decimal :eur
      t.integer :truck_id

      t.timestamps
    end
  end
end

