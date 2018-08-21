class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

    def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |element|
	      csv << element.attributes.values_at(*column_names)
	    end
	  end
	end

	def self.import(file)
	    CSV.foreach(file.path,:headers => true) do |row|
	      self.create! row.to_h
	    end
	end

end
