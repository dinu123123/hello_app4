class CreateDispatchers < ActiveRecord::Migration[5.2]
  def change
    create_table :dispatchers do |t|
      t.text :cnp
      t.text :FIRSTNAME
      t.text :SECONDNAME
      t.text :INFO
      t.text :DESCRIPTION
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
