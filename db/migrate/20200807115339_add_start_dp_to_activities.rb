class AddStartDpToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :start_ep, :integer
    add_column :activities, :start_dp, :integer
    add_column :activities, :start_op, :integer
    add_column :activities, :dest1_address, :text
    add_column :activities, :dest1_comments, :text
    add_column :activities, :dest1_unloaded_ep, :integer
    add_column :activities, :dest1_unloaded_dp, :integer
    add_column :activities, :dest1_unloaded_op, :integer
    add_column :activities, :dest1_loaded_ep, :integer
    add_column :activities, :dest1_loaded_dp, :integer
    add_column :activities, :dest1_loaded_op, :integer
    add_column :activities, :dest2_address, :text
    add_column :activities, :dest2_comments, :text
    add_column :activities, :dest2_unloaded_ep, :integer
    add_column :activities, :dest2_unloaded_dp, :integer
    add_column :activities, :dest2_unloaded_op, :integer
    add_column :activities, :dest2_loaded_ep, :integer
    add_column :activities, :dest2_loaded_dp, :integer
    add_column :activities, :dest2_loaded_op, :integer
    add_column :activities, :end_ep, :integer
    add_column :activities, :end_dp, :integer
    add_column :activities, :end_op, :integer
  end
end
