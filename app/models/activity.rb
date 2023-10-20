class Activity < ApplicationRecord
serialize :array_target, Array
serialize :array_passed_days, Array
serialize :array_missing_days, Array
serialize :waste, Array
serialize :consumption, Array

belongs_to :driver, :optional => true
belongs_to :truck, :optional => true
belongs_to :trailer, :optional => true
belongs_to :client, :required => true
belongs_to :invoiced_trip, :optional => true

#has_one_attached :picture
has_many_attached :images
has_many_attached :trip_images


def add_target(target)
	if target != nil and target.size > 0
	    self.array_target = Array.new
	    self.array_target += target
	    self.save
	end
end

def add_missing_days(target)
	if target != nil and target.size > 0
	    self.array_missing_days = Array.new
	    self.array_missing_days += target
	    self.save
    end
end

def add_passed_days(target)
	if target != nil and target.size > 0
		self.array_passed_days = Array.new
	    self.array_passed_days += target
	    self.save
    end
end

def add_waste(target)
	if target != nil and target.size > 0
		self.waste = Array.new
	    self.waste += target
	    self.save
    end
end

def add_consumption(target)
	if target != nil and target.size > 0
		self.consumption = Array.new
	    self.consumption += target
	    self.save
    end
end

end
