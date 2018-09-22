class ChangeDateFormatInEvents < ActiveRecord::Migration[5.1]
  
 def up
    change_column :events, :DATE, :datetime
  end

  def down
    change_column :events, :DATE, :date
  end

end
