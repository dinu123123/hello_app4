class DriverExpense < ApplicationRecord
  belongs_to :driver , :optional => true
  validates_uniqueness_of :DRIVER_id, scope: %i[DATE AMOUNT]
end
