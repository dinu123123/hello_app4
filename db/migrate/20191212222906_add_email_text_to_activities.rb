class AddEmailTextToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :email_text, :text
  end
end
