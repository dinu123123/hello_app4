class AddActiveToTrucks < ActiveRecord::Migration[5.2]
  def change
    add_column :trucks, :active, :boolean
  end
end
