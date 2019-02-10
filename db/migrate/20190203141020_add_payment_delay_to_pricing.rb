class AddPaymentDelayToPricing < ActiveRecord::Migration[5.2]
  def change
    add_column :pricings, :PaymentDelay, :integer
  end
end
