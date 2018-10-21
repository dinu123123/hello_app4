class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

    def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    @column_names_local = column_names
	#   @column_names_local.delete('id')
	    csv << @column_names_local
	    all.each do |element|
	      csv << element.attributes.values_at(*@column_names_local)
	    end
	  end
	end

	def self.import(file)
	    CSV.foreach(file.path,:headers => true) do |row|
	      self.create! row.to_h
	    end
	end

end
