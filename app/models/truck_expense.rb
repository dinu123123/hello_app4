class TruckExpense < ApplicationRecord
	belongs_to :truck, :optional => true
	validates_uniqueness_of :truck_id, scope: %i[DATE AMOUNT]



	 def blank?

asdasdasd

	    !self.attributes.find do |key, value| 
	    	puts ">>>>>>>>>>>>>>>>>>>> ".to_s	
	      case (key)
	      when 'id', 'created_at', 'updated_at'
	        false
	      else
	        value.present?
	        
	        	puts ">>>>>>>>>>>>>>>>>>>> ".to_s+ value.present.to_s
	        
	      end
	    end
    end
end
