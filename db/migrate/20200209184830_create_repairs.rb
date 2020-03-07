class CreateRepairs < ActiveRecord::Migration[5.2]
  def change
    create_table :repairs do |t|
      t.date :date_repair
      t.integer :km
      t.integer :DRIVER_id
      t.integer :truck_id
      t.integer :trailer_id
      t.integer :driver_expense_id
      t.integer :truck_expense_id
      t.text :description
      t.string :mechanic_name

      t.timestamps
    end
  end
end
