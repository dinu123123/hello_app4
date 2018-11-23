class AddKpriceToClients < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :kprice, :decimal
  end
end
