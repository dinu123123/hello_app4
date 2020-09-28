class AddExpectedDateToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :expected_date, :date
  end
end
