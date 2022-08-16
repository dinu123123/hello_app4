class ChangeDateFormatInTruckExpense < ActiveRecord::Migration[5.2]
   def up
   change_column :truck_expenses, :DATE, :datetime
  end

  def down
   change_column :truck_expenses, :DATE, :date
  end
end
