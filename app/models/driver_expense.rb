class DriverExpense < ApplicationRecord
  belongs_to :driver, :optional => true
  belongs_to :truck, :optional => true
  validates_uniqueness_of :DRIVER_id, scope: %i[DATE AMOUNT DESCRIPTION]
  has_many_attached :images
end
