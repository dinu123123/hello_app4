class Invoice < ApplicationRecord
	has_many :invoiced_trips
end
