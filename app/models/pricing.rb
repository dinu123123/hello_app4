class Pricing < ApplicationRecord
	belongs_to :client, :required => true
end
