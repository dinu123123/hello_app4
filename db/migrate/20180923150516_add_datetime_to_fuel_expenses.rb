class AddDatetimeToFuelExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :fuel_expenses, :datetime, :datetime
  end
end
