class AddDispatcherIdToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :dispatcher_id, :integer
  end
end
