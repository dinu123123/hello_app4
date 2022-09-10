class AddManualToBeTolls < ActiveRecord::Migration[5.2]
  def change
    add_column :be_tolls, :manual, :boolean, default: true
  end
end
