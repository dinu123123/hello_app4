class Event < ApplicationRecord
belongs_to :driver, :optional => true
belongs_to :truck, :optional => true
belongs_to :client, :required => true
validates_uniqueness_of :DRIVER_id, scope: %i[DATE START_END]




# id: 1, DATE: "2018-01-31", DRIVER_id: 1, truck_id: 1, START_END: true,client_id: 1, 
# created_at: "2018-08-09 19:53:49", updated_at: "2018-08-19 23:56:35">

# Date	Driver CNP	First Name	Second Name	Client Name	Number Plate	Start/End	


def self.to_csv_special(options = {})
    @trucks = Truck.all
    @drivers = Driver.all
    @clients = Client.all


    @events = all.find_by_sql(['SELECT * FROM events ORDER BY events."DRIVER_id" ASC, events."DATE" ASC'])
 

	  CSV.generate(options) do |csv|
	    csv << ["Date","Driver CNP","First Name","Second Name","Client","Number Plate","Start/End"]
	    @events.each_with_index do |element,i|
          array = Array.new
          
          #Date 
          array[0] = element.attributes.values_at("DATE")[0].to_date
         
          #Driver CNP
          array[1] = 
          ((@drivers.find(element.attributes.values_at("DRIVER_id")[0])).CNP)
	      
          #Driver First Name
          array[2] = 
          ((@drivers.find(element.attributes.values_at("DRIVER_id")[0])).FIRSTNAME)
	      
          #Driver Second Name
          array[3] = 
          ((@drivers.find(element.attributes.values_at("DRIVER_id")[0])).SECONDNAME)
	      
	      #Client Name
          array[4] = 
          ((@clients.find(element.attributes.values_at("client_id")[0])).Name)

          #Number Plate
          array[5] = 
          ((@trucks.find(element.attributes.values_at("truck_id")[0])).NB_PLATE)
          
          #Start/End
          array[6] = element.attributes.values_at("START_END")[0]

	      csv << array
	    end
	  end
	end

	 

	def self.import(file)
	    CSV.foreach(file.path,:headers => true) do |row|
	      @my_row = Hash.new

          @my_row["truck_id"] = (Truck.find_by NB_PLATE:row.to_a[5][1].gsub(/\s+/, "")).id
          @my_row["DATE"] = row[0]
          @my_row["DRIVER_id"] =  (Driver.find_by CNP:row.to_a[1][1].gsub(/\s+/, "")).id
          @my_row["START_END"] = row[6]
          @my_row["client_id"] =  (Client.find_by Name:row.to_a[4][1]).id
          self.create! @my_row.to_h
	    end
	end
 











end
