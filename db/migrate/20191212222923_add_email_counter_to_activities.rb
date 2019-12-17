class AddEmailCounterToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :email_counter, :integer
  end
end
