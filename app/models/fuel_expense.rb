class FuelExpense < ApplicationRecord
 require 'csv'
 belongs_to :truck, :optional => true
 validates_uniqueness_of :trstime, scope: %i[product truck_id trstdate stationname]


validates_uniqueness_of :car_model_name, scope: %i[brand_id fuel_type_id]

 #CSV.read(file.path, :quote_char => "\´")
 def self.import(file)
    # a block that runs through a loop in our CSV data
     CSV.foreach(file.path, headers: true, encoding: "ISO-8859-1",  
                           :col_sep => ";", 
                           :quote_char => "\"", 
                           :header_converters => lambda { |h| h.try(:downcase).try(:gsub,' ', '').try(:gsub,'ï»¿', '') }
                ) do |row| 
        @my_truck = Truck.find_by NB_PLATE:row.to_a[6][1].try(:gsub,' ', '')
        if @my_truck != nil and row.to_a[6][1].to_d > 0 
        	@my_row = row.to_a<<(["truck_id",@my_truck.id]) 
 	 	    	FuelExpense.create! @my_row.to_h
 	 	    else
 	 		    @my_row = row.to_a<<(["truck_id",17.to_i]) 
 	 		    FuelExpense.create! @my_row.to_h
 	 	    end	
     end
 end
 
end