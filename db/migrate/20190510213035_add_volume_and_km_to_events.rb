class AddVolumeAndKmToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :volume, :decimal
    add_column :events, :km, :decimal
  end
end
