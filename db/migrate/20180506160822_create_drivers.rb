 class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.text :CNP
      t.text :FIRSTNAME
      t.text :SECONDNAME
      t.date :StartDate
      t.date :EndDate
      t.integer :INFO
      t.text :DESCRIPTION
      t.timestamps
    end
  end
end
