class InvoicedTrip < ApplicationRecord
belongs_to :driver, :optional => true
belongs_to :truck, :optional => true
belongs_to :client, :required => true
belongs_to :invoice, :required => true

#validates_uniqueness_of :client_id, scope: %i[StartDate EndDate DRIVER_id]
validates_uniqueness_of :client_id, scope: %i[StartDate.to_date EndDate.to_datee truck_id]
end
