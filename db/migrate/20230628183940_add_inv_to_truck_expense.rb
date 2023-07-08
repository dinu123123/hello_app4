class AddInvToTruckExpense < ActiveRecord::Migration[5.2]
  def change
    add_column :truck_expenses, :inv, :boolean, default: false
  end

end
