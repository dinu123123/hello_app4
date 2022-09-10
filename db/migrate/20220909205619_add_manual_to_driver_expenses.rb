class AddManualToDriverExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :driver_expenses, :manual, :boolean, default: true
  end
end
