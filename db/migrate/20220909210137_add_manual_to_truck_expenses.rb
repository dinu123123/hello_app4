class AddManualToTruckExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :truck_expenses, :manual, :boolean, default: true
  end
end
