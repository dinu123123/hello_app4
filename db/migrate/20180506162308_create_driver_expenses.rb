class CreateDriverExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :driver_expenses do |t|
      t.text :DRIVER_id
      t.integer :truck_id
      t.date :DATE
      t.decimal :AMOUNT
      t.text :INFO
      t.text :DESCRIPTION

      t.timestamps
    end
  end
end
