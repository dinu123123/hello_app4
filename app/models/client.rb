class Client < ApplicationRecord
	has_many :invoiced_trips
	has_many :events
    validates_uniqueness_of :Name, scope: %i[Address]
end
