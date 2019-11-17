class CreatePeriodicsCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :periodics_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
