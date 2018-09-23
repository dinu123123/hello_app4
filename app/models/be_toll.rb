class BeToll < ApplicationRecord
require 'csv'
 belongs_to :truck, :optional => true
# validates :bookingid, uniqueness: true
 
def time_convert()
 entry_time.to_time.strftime("%H %M")
end


#CSV.read(file.path, :quote_char => "\´")
def self.import(file)
row_to_skip = 0
nr_rows_insterted= 0

    # a block that runs through a loop in our CSV data
     CSV.foreach(file.path, headers: ['10','Record_Number','Reference_Number','Date_of_Detailed_Trip_Statement',
									  'Identification_of_the_road_network_user','Bill_cycle_start_date',
									  'Bill_cycle_end_date','OBU_Serial_Number','Internal_OBU_Identifier',
									  'Country_code','Licence_plate_number','Euro_Emission_Class',
									  'Gross_Combination_Weight','Payment_Method','Date_of_Processing',
									  'Date_of_Usage','Toll_Charger','Road_Type','Route','Entry_Time',
									  'Charged_Distance','Distance_Unit','Charged_Amount_excluding_VAT',
									  'Currency','VAT_Indicator'],

                           #For example
                           #CSV.read('/path/to/file', :encoding => 'windows-1251:utf-8')
                           #Would convert all strings to UTF-8.
                           #Also you can use the more standard encoding name 'ISO-8859-1'
                           #CSV.read('/..', {:headers => true, :col_sep => ';', :encoding => 'ISO-8859-1'})
                           #encoding: "windows-1251:utf-8", 
                           encoding: "ISO-8859-1", 
                           :col_sep => "|", 
                           :quote_char => "\"", 
                           :header_converters => lambda { |h| h.try(:downcase).try(:gsub,' ', '') }
                ) do |row|
                      if row_to_skip ==0
                        row_to_skip = 1
                      else                      
                        if(row.drop(1).to_a[9][1] != nil)
                              row.drop(1).to_a[19][1].try(:gsub!,',', '.')
                              row.drop(1).to_a[21][1].try(:gsub!,',', '.')
                              @my_truck = Truck.find_by NB_PLATE:row.drop(1).to_a[9][1].gsub(/\s+/, "")
                              @my_row = row.drop(1).to_a<<(["truck_id",@my_truck.id]) 

                              @my_row_datetime = row.to_a[15][1]+ "T" + row.to_a[19][1]
                              @my_row = @my_row.to_a<<(["datetime",@my_row_datetime]) 

                              BeToll.create! @my_row.to_h
                        end
                      end
                   end
     end








end
