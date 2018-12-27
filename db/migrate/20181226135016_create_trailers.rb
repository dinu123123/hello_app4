class CreateTrailers < ActiveRecord::Migration[5.2]
  def change
    create_table :trailers do |t|
      t.string :NB_PLATE
      t.string :INFO
      t.string :CHASSIS
      t.date :FABDATE

      t.timestamps
    end
  end
end
