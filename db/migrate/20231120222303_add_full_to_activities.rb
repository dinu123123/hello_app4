class AddFullToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :full, :boolean, default: false
  end
end
