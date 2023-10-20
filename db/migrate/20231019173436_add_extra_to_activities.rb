class AddExtraToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :waste, :array
    add_column :activities, :consumption, :array
  end
end
