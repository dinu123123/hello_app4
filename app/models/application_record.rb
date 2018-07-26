class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def blank?
	    !self.attributes.find do |key, value| 

	    	
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
