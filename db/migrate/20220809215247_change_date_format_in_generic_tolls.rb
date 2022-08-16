class ChangeDateFormatInGenericTolls < ActiveRecord::Migration[5.2]
  def up
    change_column :generic_tolls, :StartDate, :datetime
    change_column :generic_tolls, :EndDate, :datetime
  end

  def down
    change_column :generic_tolls, :StartDate, :date
    change_column :generic_tolls, :EndDate, :date
  end
end