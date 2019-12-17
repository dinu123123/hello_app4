class AddTripsEmailToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :trips_email, :string
  end
end
