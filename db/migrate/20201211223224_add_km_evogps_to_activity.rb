class AddKmEvogpsToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :km_evogps, :integer
  end
end
