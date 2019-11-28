class Checkin < ApplicationRecord
  validates :driver_cpf, :driver_name, :operation_type, :status,  presence: true
  validates :door, presence: true, numericality: { greater_than: 0 }, if: :boarding?
  #validates :driver_cpf, uniqueness: { scope: [:operation_type, :operation_id, :status], message: "Driver already checked in today." }

  enum operation_type: { input_control: 0, boarding: 1}
  enum status: { input: 0, start: 1, finish: 2, checkout: 3}

  scope :the_day, -> { where("DATE(created_at) = ?", Date.current).order("id desc") }
  scope :day, ->(day) { where("DATE(created_at) = ?", day).order("id desc") }
  scope :inside_all, -> {where(status: [:input, :start, :finish])}
  scope :driver_status, ->(cpf) {where(driver_cpf: cpf).order(id: :asc).last}

  #Testar esse metodo
  #validate :check_driver_already_checkin?

  before_create :validation_checkin, :if => :check_driver_already_checkin?

  before_create do |item|
    item.place_horse  = item.place_horse.upcase if item.place_horse.present?
    item.place_cart_1 = item.place_cart_1.upcase if item.place_cart_1.present?
    item.place_cart_2 = item.place_cart_2.upcase if item.place_cart_2.present?
  end

  ransacker :created_at , type: :date do
    Arel.sql('date(checkins.created_at)')
  end

  def validation_checkin
    Checkin.the_day.where(driver_cpf: self.driver_cpf, operation_type: self.operation_type, operation_id: self.operation_id, status: self.status).present?
  end

  def self.service_checkout(driver_cpf, operation)
    driver = Driver.where(cpf: driver_cpf).first
    checkin = Checkin.input.where(driver_cpf: driver.cpf).last
    Checkin.create!( driver_cpf: driver_cpf,
                   driver_name: driver.nome.upcase,
                operation_type: operation,
                  operation_id: checkin.operation_id,
                   place_horse: checkin.place_horse,
                  place_cart_1: checkin.place_cart_1,
                  place_cart_2: checkin.place_cart_2,
                          door: checkin.door,
                        status: :checkout)
  end

  def places
    str_places = self.place_horse
    str_places += ", #{self.place_cart_1 }" if self.place_cart_1.present?
    str_places += ", #{self.place_cart_2 }" if self.place_cart_2.present?
    str_places
  end

  # belongs_to :checkin_input_control, class_name: "InputControl", foreign_key: "operation_id", polymorphic: true, required: false
  # belongs_to :checkin_boarding, class_name: "Boarding", foreign_key: "operation_id", polymorphic: true, required: false
  def input_control
    InputControl.where(id: self.operation_id).first
  end

  def boarding
    Boarding.where(id: self.operation_id).first
  end

  #private
  def check_driver_already_checkin?
    validation_checkin
  end
end
