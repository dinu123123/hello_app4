class AddDefaultZeroToKmEvogpsForActivity < ActiveRecord::Migration[5.2]
  def change
   change_column_default :activities, :km_evogps, from: nil, to: 0
  end
end
