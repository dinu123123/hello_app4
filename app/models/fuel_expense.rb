class FuelExpense < ApplicationRecord
 require 'csv'
 belongs_to :truck, :optional => true
 validates_uniqueness_of :trsdate, scope: %i[product truck_id]

 #CSV.read(file.path, :quote_char => "\´")
 def self.import(file)
    # a block that runs through a loop in our CSV data
     CSV.foreach(file.path, headers: true, encoding: "ISO8859-1:utf-8", 
                           :col_sep => ";", 
                           :quote_char => "\"", 
                           :header_converters => lambda { |h| h.try(:downcase).try(:gsub,' ', '') }
                ) do |row| 
        @my_truck = Truck.find_by NB_PLATE:row.to_a[6][1]
        @my_row = row.to_a<<(["truck_id",@my_truck.id]) 
 	 	FuelExpense.create! @my_row.to_h
     end
 end
end