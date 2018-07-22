class CreateTrucks < ActiveRecord::Migration[5.1]
  def change
    create_table :trucks do |t|
      t.text :NB_PLATE
      t.text :INFO
      t.text :CHASSIS
      t.date :FABDATE
      t.timestamps
    end
  end
end

#class AddUniqueIndexToTrucks < ActiveRecord::Migration[5.1]
#  def change
#    add_index :trucks, [:NB_PLATE, :CHASSIS], unique: true
#    asdas
#  end
#end

