class CreateCardEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :card_events do |t|
      t.date :date
      t.integer :truck_id
      t.integer :card_id

      t.timestamps
    end
  end
end
