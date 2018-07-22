class CreateEvents < ActiveRecord::Migration[5.1]
  def change
     create_table :events do |t|
      t.date :DATE
      t.integer :DRIVER_id
      t.integer :truck_id
      t.boolean :START_END
      t.integer :client_id

      t.timestamps
     end
  end

#  scope :created_between, 
#  lambda {|start_date, end_date| where("created_at >= ? AND created_at <= ?", start_date, end_date )}
end
