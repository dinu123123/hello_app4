class DeToll < ApplicationRecord
require 'csv'
 belongs_to :truck, :optional => true
 validates :bookingid, uniqueness: true
 
 #CSV.read(file.path, :quote_char => "\´")
 def self.import(file)
    # a block that runs through a loop in our CSV data
     CSV.foreach(file.path, headers: true, encoding: "ISO8859-1:rb:UTF-32BE:UTF-8", 
                           :col_sep => ";", 
                           :quote_char => "\"", 
                           :header_converters => lambda { |h| h.try(:downcase).try(:gsub,' ', '') }
                ) do |row| 
        @my_truck = Truck.find_by NB_PLATE:row.to_a[0][1].gsub(/\s+/, "")
        @my_row = row.to_a<<(["truck_id",@my_truck.id]) 
 	 	DeToll.create! @my_row.to_h
     end
  end

  
end
