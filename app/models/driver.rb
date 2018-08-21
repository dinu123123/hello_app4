class Driver < ApplicationRecord

has_many :driver_expenses
has_many :events
has_many :invoiced_trips
validates :CNP, uniqueness: true

def name_with_cnp
self.FIRSTNAME + " " + self.SECONDNAME + " CNP:"+ self.CNP.to_s
end

end
