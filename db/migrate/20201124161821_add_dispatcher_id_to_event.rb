class AddDispatcherIdToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :dispatcher_id, :integer
  end
end
