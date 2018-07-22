class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :Name
      t.string :Address
      t.string :BankAccount
      t.integer :PaymentDelay
      t.integer :event_id
      t.integer :client_id
      t.timestamps
    end
  end
end
