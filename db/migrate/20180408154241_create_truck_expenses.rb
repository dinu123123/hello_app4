class CreateTruckExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :truck_expenses do |t|
      t.integer :truck_id
      t.date :DATE
      t.decimal :AMOUNT
      t.text :INFO
      t.text :DESCRIPTION

      t.timestamps
    end
  end
end
