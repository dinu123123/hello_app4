class Driver < ApplicationRecord

has_many :driver_expenses
has_many :events
has_many :invoiced_trips
validates :CNP, uniqueness: true

has_many_attached :images

def name_with_cnp
self.SECONDNAME + " " + self.FIRSTNAME + " " + " CNP:"+ self.CNP.to_s
end

end
