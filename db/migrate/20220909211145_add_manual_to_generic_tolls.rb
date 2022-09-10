class AddManualToGenericTolls < ActiveRecord::Migration[5.2]
  def change
    add_column :generic_tolls, :manual, :boolean, default: true
  end
end
