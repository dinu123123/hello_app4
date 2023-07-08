class AddDueDateToDriverExpense < ActiveRecord::Migration[5.2]
  def change
    add_column :driver_expenses, :due_date, :date
  end
end
