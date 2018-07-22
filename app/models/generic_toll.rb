class GenericToll < ApplicationRecord
  belongs_to :truck
  validates_uniqueness_of :StartDate, scope: %i[EndDate truck_id]
end
