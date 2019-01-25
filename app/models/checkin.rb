class Checkin < ApplicationRecord
  validates :driver_cpf, :driver_name, :operation_type, :status,  presence: true

  #belongs_to :driver

  enum operation_type: { input_control: 0, boarding: 1}
  enum status: { input: 0, start: 1, finish: 2, checkout: 3}

  scope :the_day, -> { where("DATE(created_at) = ?", Date.current).order("id desc") }
  scope :inside_all, -> {where(status: [:input, :start, :finish])}
  scope :driver_status, ->(cpf) {where(driver_cpf: cpf).last}

  def self.service_checkout(driver_cpf, operation)
    driver = Driver.where(cpf: driver_cpf).first
    checkin = Checkin.input.where(driver_cpf: driver.cpf).last
    Checkin.create( driver_cpf: driver_cpf,
                   driver_name: driver.nome.upcase,
                operation_type: operation,
                  operation_id: checkin.operation_id,
                   place_horse: checkin.place_horse,
                  place_cart_1: checkin.place_cart_1,
                  place_cart_2: checkin.place_cart_2,
                        status: :checkout)
  end

  before_create do |v|
    v.place_horse = v.place_horse.upcase
    v.place_cart_1 = v.place_cart_1.upcase
    v.place_cart_2 = v.place_cart_2.upcase
  end
end
