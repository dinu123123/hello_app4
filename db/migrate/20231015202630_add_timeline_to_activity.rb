class AddTimelineToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :array_target, :array
    add_column :activities, :array_passed_days, :array
    add_column :activities, :array_missing_days, :array
  end
end


