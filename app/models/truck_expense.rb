class TruckExpense < ApplicationRecord
	belongs_to :truck, :optional => true
	validates_uniqueness_of :truck_id, scope: %i[DATE AMOUNT]
end
