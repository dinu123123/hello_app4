class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.string :abbr
      t.string :symbol
      t.string :name

      t.timestamps
    end
  end
end
