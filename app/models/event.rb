class Event < ApplicationRecord
belongs_to :driver, :optional => true
belongs_to :truck, :optional => true
belongs_to :client, :required => true
validates_uniqueness_of :DRIVER_id, scope: %i[DATE]
end
