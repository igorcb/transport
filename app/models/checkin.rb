class Checkin < ApplicationRecord
  validates :driver_cpf, :driver_name, :operation, :status,  presence: true

  #belongs_to :driver

  enum operation: { input_control: 0, boarding: 1}
  enum status: { input: 0, start: 1, finish: 2, checkout: 3}

  scope :the_day, -> { where("DATE(created_at) = ?", Date.current).order("id desc") }
  scope :inside_all, -> {where(status: [:input, :start, :finish])}
  scope :driver_status, ->(cpf) {where(driver_cpf: cpf).last}

  def self.service_checkout(driver_cpf, operation)
    driver = Driver.where(cpf: driver_cpf).first
    Checkin.create(driver_cpf: driver_cpf, driver_name: driver.nome.upcase, operation: operation, status: :checkout)
  end

  before_save do |v|
    v.place_horse = v.place_horse.upcase
    v.place_cart_1 = v.place_cart_1.upcase
    v.place_cart_2 = v.place_cart_1.upcase
  end
end
