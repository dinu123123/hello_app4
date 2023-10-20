class AddOdometerToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :odometer, :integer
  end
end
