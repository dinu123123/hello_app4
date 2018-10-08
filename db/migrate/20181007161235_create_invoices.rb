class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.string :name
      t.string :info
      t.date :date
      t.integer :client_id
      t.decimal :vat
      t.decimal :total_amount
      t.timestamps
    end
  end
end
