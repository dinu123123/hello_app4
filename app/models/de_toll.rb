class DeToll < ApplicationRecord
require 'csv'
 belongs_to :truck, :optional => true
 validates :bookingid, uniqueness: true
 
#CSV.read(file.path, :quote_char => "\´")
def self.import(file)
row_to_skip = 0
nr_rows_insterted= 0

    # a block that runs through a loop in our CSV data
     CSV.foreach(file.path, headers: ['Nothing','PlateNr', 'Date', 'Time', 'BookingID', 
                                      'Art', 'Road ', 'Via', 'Departure', 'CostCentre', 
                                      'TariffModel', 'AxelClass', 'WeightClass', 'EmissionCat', 
                                      'RoadOperators', 'Ver', 'Km ', 'EUR'], 

                           #For example
                           #CSV.read('/path/to/file', :encoding => 'windows-1251:utf-8')
                           #Would convert all strings to UTF-8.
                           #Also you can use the more standard encoding name 'ISO-8859-1'
                           #CSV.read('/..', {:headers => true, :col_sep => ';', :encoding => 'ISO-8859-1'})
                           #encoding: "windows-1251:utf-8", 
                           encoding: "ISO-8859-1", 
                           :col_sep => ";", 
                           :quote_char => "\"", 
                           :header_converters => lambda { |h| h.try(:downcase).try(:gsub,' ', '') }
                ) do |row|
                      if row_to_skip ==0
                        row_to_skip = 1
                      else                      
                        if(row.drop(1).to_a[0][1] != nil)
                              @my_truck = Truck.find_by NB_PLATE:row.drop(1).to_a[0][1].gsub(/\s+/, "")
                              @my_row = row.drop(1).to_a<<(["truck_id",@my_truck.id]) 
                              DeToll.create! @my_row.to_h
                        end
                      end
                   end
     end
end
