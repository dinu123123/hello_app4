class AddPalletPaymentsToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :pallets_paid_in, :text
    add_column :activities, :pallets_paid_out, :text
  end
end
