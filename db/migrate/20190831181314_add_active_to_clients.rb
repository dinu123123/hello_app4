class AddActiveToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :active, :boolean
  end
end
