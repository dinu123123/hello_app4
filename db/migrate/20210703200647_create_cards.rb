class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :provider
      t.string :name
      t.string :card_id
      t.string :pin
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
