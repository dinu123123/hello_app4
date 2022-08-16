class GenericToll < ApplicationRecord
  belongs_to :truck, :optional => true
  validates_uniqueness_of :StartDate, scope: %i[Km truck_id EUR]
end
