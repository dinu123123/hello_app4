class FuelExpense < ApplicationRecord
 require 'csv'
 belongs_to :truck, :optional => true
 validates_uniqueness_of :trstime, scope: %i[product truck_id trsdate stationname]

 #CSV.read(file.path, :quote_char => "\´")
 def self.import(file)
    # a block that runs through a loop in our CSV data
     CSV.foreach(file.path, headers: true, encoding: "ISO-8859-1",  
                           :col_sep => ";", 
                           :quote_char => "\"", 
                           :header_converters => lambda { |h| h.try(:downcase).try(:gsub,' ', '').try(:gsub,'ï»¿', '') }
                ) do |row| 
        @my_truck = Truck.find_by NB_PLATE:row.to_a[6][1].try(:gsub,' ', '')

        if @my_truck != nil 
          if  row.to_a[3][1].to_d > 0.to_d
             #do not register transactions with zero value 
        	   @my_row = row.to_a<<(["truck_id",@my_truck.id]) 
             @my_row_datetime = row.to_a[1][1].try(:gsub!,'/', '-')+ "T" + row.to_a[0][1]
             @my_row = @my_row.to_a<<(["datetime",@my_row_datetime]) 
             @my_EuroNetAmountInclVATFreeCharges =  row["eurnetamount"].to_d+row["volume"].to_d*0.0152
             @my_row = @my_row.to_a<<(["EuroNetAmountInclVATFreeCharges",@my_EuroNetAmountInclVATFreeCharges.round(2)])
 	 	    	   FuelExpense.create! @my_row.to_h
           end
 	 	    else
          #hope one day we will have 1001 trucks
          #but then that wont be a problem 
 	 		    @my_row = row.to_a<<(["truck_id",23.to_i]) 
          @my_row_datetime = row.to_a[1][1].try(:gsub!,'/', '-')+ "T" + row.to_a[0][1]
          @my_row = @my_row.to_a<<(["datetime",@my_row_datetime]) 
          @my_EuroNetAmountInclVATFreeCharges =  row["eurnetamount"].to_d+row["volume"].to_d*0.0152
          @my_row = @my_row.to_a<<(["EuroNetAmountInclVATFreeCharges",@my_EuroNetAmountInclVATFreeCharges.round(2)])
 	 		    FuelExpense.create! @my_row.to_h
 	 	    end	
     end
 end





def self.import_as24(file)
    @BELVAT_FREE = false
    #value considered to be charged by BHI for VAT recovery
    @BELVAT_FREE_CHARGES = "0.07".to_d
    @BELVAT = "0.21".to_d

    @DEUVAT_FREE = true
    @DEUVAT_FREE_CHARGES = "0.055".to_d
    @DEUVAT = "0.19".to_d

    @NLDVAT_FREE = true
    @NLDVAT_FREE_CHARGES = "0.055".to_d  
    @NLDVAT = "0.21".to_d


    row_to_skip = 0
        # a block that runs through a loop in our CSV data
         CSV.foreach(file.path,  headers: [
    'Contract',
    'Vehicle_card',
    'Driver_card',
    'Product_code',
    'Product',
    'Volume',
    'Date',
    'Time',
    'Country',
    'Site_nbr',
    'Station',
    'Invoice_date',
    'Invoice_nbr',
    'VAT_rate',
    'Transation_currency',
    'Excl_VAT',
    'VAT',
    'Incl_VAT',
    'Payment_currency',
    'Excl_VAT',
    'VAT',
    'Incl_VAT',
    'Miles',
    'Immatriculation',
    'Document_type'],
     encoding: "ISO-8859-1",  
                               :col_sep => ";", 
                               :quote_char => "\"", 
                               :header_converters => lambda { |h| h.try(:gsub,' ', '').try(:gsub,'ï»¿', '') }
                    ) do |row| 

     if row_to_skip ==0
                            row_to_skip = 1
                          else  

      @my_trstime = row["Date"].to_date

      @my_trsdatetime = DateTime.new(@my_trstime.year, @my_trstime.month, @my_trstime.day, row["Time"][0,2].to_i , row["Time"][2,2].to_i, 0.to_i, DateTime.now.zone)


      @my_trsdate = @my_trsdatetime.to_time

      @my_product = row["Product"].to_s.try(:gsub,' ', '')

      @my_volume = row["Volume"].to_d
      @my_country = row["Country"].to_s.try(:gsub,' ', '')

      @my_kminsertion = row["Miles"].to_d
      @my_truck = row["Immatriculation"].to_s.try(:gsub,' ', '')
      @my_cardnr = row["Vehicle_card"].to_s.try(:gsub,' ', '')
      @my_stationid = row["Site_nbr"].to_s.try(:gsub,' ', '')
      @my_stationname = row["stationname"].to_s.try(:gsub,' ', '')
      @my_eurgrossunitprice = 0.to_d
      @my_eurgrossamount = row["Incl_VAT"].to_d
      @my_truck_all_data = Truck.find_by NB_PLATE:@my_truck.try(:gsub,' ', '')
      @my_truck_id = @my_truck_all_data.id


      @my_row = Hash.new
      @my_row = @my_row.to_a<<(["trstime",@my_trsdatetime.to_time])
      @my_row = @my_row.to_a<<(["trsdate",@my_trsdatetime.to_date])
      @my_row = @my_row.to_a<<(["product",@my_product])
      @my_row = @my_row.to_a<<(["volume",@my_volume])
      @my_row = @my_row.to_a<<(["kminsertion",@my_kminsertion])
      @my_row = @my_row.to_a<<(["platenr",@my_truck])
      @my_row = @my_row.to_a<<(["cardnr",@my_cardnr])
      @my_row = @my_row.to_a<<(["stationid",@my_stationid])
      @my_row = @my_row.to_a<<(["stationname",@stationname])
      @my_row = @my_row.to_a<<(["eurgrossunitprice",@my_eurgrossunitprice])
      @my_row = @my_row.to_a<<(["eurgrossamount",@my_eurgrossamount])
      @my_row = @my_row.to_a<<(["country",@my_country])
      @my_row = @my_row.to_a<<(["truck_id",@my_truck_id])

 
      #default
      @my_EuroNetAmountInclVATFreeCharges = (row["Incl_VAT"].to_d/(1+0.19))*(1+@BELVAT_FREE_CHARGES)
      @my_eurnetamount = (row["Incl_VAT"].to_d/(1+0.19))

      if @my_country== "BEL"
        @my_EuroNetAmountInclVATFreeCharges = (@my_eurgrossamount/(1+@BELVAT))+(@my_eurgrossamount - (@my_eurgrossamount/(1+@BELVAT))  )*@BELVAT_FREE_CHARGES
        @my_eurnetamount = (@my_eurgrossamount/(1+@BELVAT))     
      end

      if @my_country== "DEU"
        @my_EuroNetAmountInclVATFreeCharges = (@my_eurgrossamount/(1+@DEUVAT))+(@my_eurgrossamount- (@my_eurgrossamount/(1+@DEUVAT)))  *@DEUVAT_FREE_CHARGES
        @my_eurnetamount = (@my_eurgrossamount/(1+@DEUVAT))
      end

      if @my_country== "NLD"
        @my_EuroNetAmountInclVATFreeCharges = (@my_eurgrossamount/(1+@NLDVAT))+(@my_eurgrossamount-  (@my_eurgrossamount/(1+@NLDVAT)) )  *@NLDVAT_FREE_CHARGES
        @my_eurnetamount = (@my_eurgrossamount/(1+@NLDVAT))
      end

      @my_row = @my_row.to_a<<(["eurnetamount",@my_eurnetamount.round(2)])
      @my_row = @my_row.to_a<<(["EuroNetAmountInclVATFreeCharges",@my_EuroNetAmountInclVATFreeCharges.round(2)])
      
      @my_row_datetime =@my_trsdate.to_s + "T" + @my_trstime.to_s

            if @my_truck != nil 
              if  @my_eurgrossamount > 0.to_d
                 #do not register transactions with zero value 
                 @my_row = @my_row.to_a<<(["truck_id",@my_truck_id]) 
                 #@my_row_datetime = row.to_a[1][1].try(:gsub!,'/', '-')+ "T" + row.to_a[0][1]



                 @my_row = @my_row.to_a<<(["datetime",@my_row_datetime]) 
                 FuelExpense.create! @my_row.to_h


               end
            else
              #hope one day we will have 1001 trucks
              #but then that wont be a problem 
              @my_row = @my_row.to_a<<(["truck_id",23.to_i]) 
              #@my_row_datetime = row.to_a[1][1].try(:gsub!,'/', '-')+ "T" + row.to_a[0][1]
              @my_row = @my_row.to_a<<(["datetime",@my_row_datetime]) 
              FuelExpense.create! @my_row.to_h
            end 
         end
     end
    end
 


end
