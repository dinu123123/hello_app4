class Activity < ApplicationRecord
belongs_to :driver, :optional => true
belongs_to :truck, :optional => true
belongs_to :trailer, :optional => true
belongs_to :client, :required => true
belongs_to :invoiced_trip, :optional => true



#has_one_attached :picture
has_many_attached :images
has_many_attached :trip_images

end
