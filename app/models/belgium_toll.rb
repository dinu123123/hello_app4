class BelgiumToll < ApplicationRecord
 belongs_to :truck
 validates_uniqueness_of :StartDate, scope: %i[StartTime truck_id]
end
