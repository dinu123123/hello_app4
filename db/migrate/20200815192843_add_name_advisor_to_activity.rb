class AddNameAdvisorToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :name_advisor, :string
  end
end
