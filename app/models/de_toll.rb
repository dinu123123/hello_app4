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
                              row.drop(1).to_a[15][1].try(:gsub!,',', '.')
                              row.drop(1).to_a[16][1].try(:gsub!,',', '.')
                              @my_truck = Truck.find_by NB_PLATE:row.drop(1).to_a[0][1].gsub(/\s+/, "")
                              @my_row = row.drop(1).to_a<<(["truck_id",@my_truck.id])              
                              @my_row_datetime = row.to_a[2][1].try(:gsub!,'.', '-')+ "T" + row.to_a[3][1]
                              @my_row = @my_row.to_a<<(["datetime",@my_row_datetime]) 
                              DeToll.create! @my_row.to_h
                              
                        end
                      end
                   end
     end


def self.import_as24(file)
row_to_skip = 0
nr_rows_insterted= 0




    # a block that runs through a loop in our CSV data
     CSV.foreach(file.path, headers: [
'OFFER_TYPE',
'PARTNER_ID',
'PARTNER_NAME',
'COUNTRY',
'CUSTOMER_ID',
'CUSTOMER_NAME',
'ID_GROUP',
'OBU_TYPE',
'PAN',
'OBU_ID',
'TRANSPONDER_NUMBER',
'TRANSPONDER_RANK',
'LICENSE_PLATE_NUMBER',
'EUROCLASS',
'MAX_WEIGHT',
'CMV',
'TRANSACTION_ID',
'OBU_SERIAL_NUMBER_ID',
'DATE_TIME_TRANSACTION',
'ROAD_CODE',
'ROAD_TYPE',
'ROAD_NAME',
'DATE_TIME_START',
'LATITUDE_START',
'LONGITUDE_START',
'DATE_TIME_END',
'LATITUDE_END',
'LONGITUDE_END',
'CHARGED_DISTANCE',
'AMOUNT_EXCLUDING_VAT',
'VAT_AMOUNT',
'AMOUNT_TAX_INCLUDED',
'CURRENCY',
'INTERNAL_AS24_ID',
'INTERNAL_PARTNER__ID',
'DATE_INTERNAL_AS24',
'DATE_INTERNAL_PARTNER',
'START_ADDRESS',
'END_ADDRESS'], 


                           #For example
                           #CSV.read('/path/to/file', :encoding => 'windows-1251:utf-8')
                           #Would convert all strings to UTF-8.
                           #Also you can use the more standard encoding name 'ISO-8859-1'
                           #CSV.read('/..', {:headers => true, :col_sep => ';', :encoding => 'ISO-8859-1'})
                           #encoding: "windows-1251:utf-8", 
                           encoding: "ISO-8859-1,windows-1251:utf-8", 
                           :col_sep => ";", 
                           :quote_char => "|", 
                           :header_converters => lambda { |h| h.try(:gsub,' ', '') }
                ) do |row|
                      if row_to_skip ==0
                        row_to_skip = 1
                      else      

                        if(row.drop(1).to_a[0][1] != nil)


      @my_platenr =  row["LICENSE_PLATE_NUMBER"].try(:gsub,' ', '').try(:gsub,'"', '')
      @my_date = row["DATE_TIME_START"].try(:gsub,' ', '').try(:gsub,'"', '').to_date
      @my_time = "12:00".to_time


     @my_datetime = @my_date.to_s+ "T" + @my_time.to_s
     @my_row = @my_row.to_a<<(["datetime",@my_datetime]) 


      @my_bookingid = row["TRANSACTION_ID"].try(:gsub,' ', '').try(:gsub,'"', '') 
      @my_art = "0".to_s
      @my_road = "".to_s
      @my_via = "".to_s
      @my_departure = "".to_s
      @my_costcentre = "0".to_i
      
      @my_tariffmodel = "0".to_i
      @my_axelclass = "0".to_i
      @my_weightclass = "0".to_i
      @my_emissioncat = "0".to_i
      @my_roadoperators = "0".to_i


      @my_ver = "-".to_s
      @my_km = "0".to_d
      @my_eur = row["AMOUNT_TAX_INCLUDED"].try(:gsub,' ', '').try(:gsub,'"', '').to_d



      if @my_platenr == "-"
          @my_truck_id =  23
          @my_platenr = "Birou".to_s
      else
          @my_truck_id_ROW = Truck.find_by  NB_PLATE:@my_platenr

          if  @my_truck_id_ROW == nil
            @my_truck_id =  23
            @my_platenr = "Birou".to_s
          else
            @my_truck_id = @my_truck_id_ROW.id
          end
      end


      @my_row = @my_row.to_a<<(["platenr",@my_platenr])<<(["date",@my_date])<<(["time",@my_time])
      @my_row = @my_row.to_a<<(["bookingid",@my_bookingid])<<(["art",@my_art])<<(["road",@my_road])

 @my_row = @my_row.to_a<<(["via",@my_via])<<(["art",@art])<<(["road",@my_road])
@my_row = @my_row.to_a<<(["eur",@my_eur])<<(["truck_id",@my_truck_id])



                              DeToll.create! @my_row.to_h
                              
                        end
                      end
                   end
     end





end
