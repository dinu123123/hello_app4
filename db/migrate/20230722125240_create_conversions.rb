class CreateConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :conversions do |t|
      t.date :date
      t.decimal :conversion_rate
      t.integer :currency_id

      t.timestamps
    end
  end
end
