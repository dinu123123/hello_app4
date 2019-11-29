class AddReferencesToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :references, :text
  end
end
