class AddDatetimeToDeTolls < ActiveRecord::Migration[5.1]
  def change
    add_column :de_tolls, :datetime, :datetime
  end
end
