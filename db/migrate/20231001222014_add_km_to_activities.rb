class AddKmToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :km, :integer
  end
end
