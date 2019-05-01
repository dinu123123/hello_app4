class AddEuroNetAmountInclVatFreeChargesToFuelExpense < ActiveRecord::Migration[5.2]
  def change
    add_column :fuel_expenses, :EuroNetAmountInclVATFreeCharges, :decimal
  end
end
