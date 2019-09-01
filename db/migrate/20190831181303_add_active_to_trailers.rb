class AddActiveToTrailers < ActiveRecord::Migration[5.2]
  def change
    add_column :trailers, :active, :boolean
  end
end
