class AddTrailerIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :trailer_id, :integer
  end
end
