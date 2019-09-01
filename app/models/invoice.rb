class Invoice < ApplicationRecord
	has_many :invoiced_trips
	validates_uniqueness_of :name

end
