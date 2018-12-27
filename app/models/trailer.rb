class Trailer < ApplicationRecord
	validates :NB_PLATE, uniqueness: true
	has_many :events
end
