class AddExtraToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :client_target, :int
    add_column :activities, :days_with_client, :int
  end
end
