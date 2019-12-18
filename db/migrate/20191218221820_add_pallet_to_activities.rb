class AddPalletToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :pallet, :integer
  end
end
