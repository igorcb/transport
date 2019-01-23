class Checkin < ApplicationRecord
  validates :driver_cpf, :driver_name, :operation, :status,  presence: true

  #belongs_to :driver

  enum operation: { input_control: 0, boarding: 1}
  enum status: { input: 0, start: 1, finish: 2, checkout: 3}

  scope :the_day, -> { where("DATE(created_at) = ?", Date.current).order("id desc") }
  scope :inside_all, -> {where(status: [:input, :start, :finish])}
  scope :driver_status, ->(cpf) {where(driver_cpf: cpf).last}
end
