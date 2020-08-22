class AddStartDayToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :km_destination, :integer
    add_column :activities, :starting_time, :time
    add_column :activities, :driving_time_left, :time
    add_column :activities, :end_time, :time
    add_column :activities, :night_break, :time
    add_column :activities, :weekend_break, :integer
  end
end
