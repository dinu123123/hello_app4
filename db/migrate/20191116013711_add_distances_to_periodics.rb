class AddDistancesToPeriodics < ActiveRecord::Migration[5.2]
  def change
    add_column :periodics, :km_start, :integer
    add_column :periodics, :km_end, :integer
  end
end
