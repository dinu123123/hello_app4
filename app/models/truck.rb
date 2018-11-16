class Truck < ApplicationRecord
	validates :NB_PLATE, uniqueness: true
	validates :CHASSIS, uniqueness: true

	#validates :NB_PLATE, uniqueness: { scope: :CHASSIS,
	#    message: "should happen once per year" }

	has_many :truck_expenses
	has_many :belgium_tolls
	has_many :germany_tolls
	has_many :de_tolls
	has_many :generic_tolls
	has_many :events
	has_many :invoiced_trips

end