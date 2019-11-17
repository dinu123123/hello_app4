class CreatePeriodics < ActiveRecord::Migration[5.2]
  def change
    create_table :periodics do |t|
      t.integer :periodics_category_id
      t.date :date_start
      t.date :date_end
      t.integer :DRIVER_id
      t.integer :truck_id
      t.integer :trailer_id
      t.integer :days_valid
      t.integer :driver_expense_id
      t.integer :truck_expense_id

      t.timestamps
    end
  end
end
