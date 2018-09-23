class AddDatetimeToBeTolls < ActiveRecord::Migration[5.1]
  def change
    add_column :be_tolls, :datetime, :datetime
  end
end
