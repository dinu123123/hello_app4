class InvoicedTrip < ApplicationRecord
belongs_to :driver, :optional => true
belongs_to :truck, :optional => true
belongs_to :client, :required => true
belongs_to :invoice, :required => true

validates_uniqueness_of :client_id, scope: %i[invoice_id StartDate EndDate DRIVER_id]	, if: -> { typeT == nil or typeT == 0 } 

validates_uniqueness_of :invoice_id , if: -> { name.present? } , if: -> { not( typeT == nil or typeT == 0) } 



has_many_attached :images
has_many_attached :bill_of_lading
has_many_attached :export_document


has_many :activities
end