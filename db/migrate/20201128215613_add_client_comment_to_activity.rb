class AddClientCommentToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :client_comment, :text
  end
end
