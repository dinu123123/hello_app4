class ChangeDateFormatInEvents < ActiveRecord::Migration[5.1]
  
 def up
    change_column :Events, :DATE, :datetime
  end

  def down
    change_column :Events, :DATE, :date
  end

end
