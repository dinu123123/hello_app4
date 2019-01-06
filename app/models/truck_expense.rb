class TruckExpense < ApplicationRecord
	belongs_to :truck, :optional => true
	validates_uniqueness_of :truck_id, scope: %i[DATE AMOUNT]
    has_many_attached :images

	def self.to_csv_special(options = {})
    @trucks = Truck.all


	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each_with_index do |element,i|
          array = Array.new
          array = element.attributes.values_at(*column_names)
          array[1] = 
          ((@trucks.find(element.attributes.values_at("truck_id")[0])).NB_PLATE)
	      csv << array
	    end
	  end
	end


	def self.import(file)
	    CSV.foreach(file.path,:headers => true) do |row|
          @my_truck = Truck.find_by NB_PLATE:row.to_a[1][1].gsub(/\s+/, "")
          @my_row = row
          @my_row[1]=@my_truck.id.to_s 
          self.create! @my_row.to_hs
	    end
	end
end
