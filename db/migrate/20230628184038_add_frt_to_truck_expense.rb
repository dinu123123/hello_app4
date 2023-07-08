class AddFrtToTruckExpense < ActiveRecord::Migration[5.2]
  def change
    add_column :truck_expenses, :frt, :boolean, default: false
  end
end
