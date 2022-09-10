class AddManualToDeTolls < ActiveRecord::Migration[5.2]
  def change
    add_column :de_tolls, :manual, :boolean, default: true
  end
end
