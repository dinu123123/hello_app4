class Conversion < ApplicationRecord
	belongs_to :currency, :optional => true
end
