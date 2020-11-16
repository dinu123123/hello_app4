class RenameTypeToTypeT < ActiveRecord::Migration[5.2]
   def change
    rename_column :invoiced_trips, :type, :typeT
 end

end
