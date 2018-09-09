class CreateDriverExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :driver_expenses do |t|
      #DRIVER_id better made as integer
      t.integer :DRIVER_id
      t.integer :truck_id
      t.date :DATE
      t.decimal :AMOUNT
      t.text :INFO
      t.text :DESCRIPTION

      t.timestamps
    end
  end
end
