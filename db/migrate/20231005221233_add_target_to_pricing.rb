class AddTargetToPricing < ActiveRecord::Migration[5.2]
  def change
    add_column :pricings, :target, :integer
  end
end
