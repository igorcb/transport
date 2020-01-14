class PalletizingsController < ApplicationController
  before_action :set_palletizing, only: [:new, :create]

  def index
    @palletizings = Palletizing.where(created_at: Date.today).or(Palletizing.where(status: :started)) if current_user.has_role? :sup
    @palletizings = Palletizing.where("created_at < ? and created_at > ?", Date.today, Date.today - 30.day).or(Palletizing.where(status: :started)) if current_user.has_role? :admin
  end

  def select_input_control
    @input_controls = InputControl.includes(:driver).where(status: InputControl::TypeStatus::RECEIVED ).where("date_scheduled <= ? and date_scheduled > ?", Date.current, Date.current-30.day).order("id desc")
  end

  def view_mode_change
    @palletizing = Palletizing.where(id: params[:id]).first
    @input_control = @palletizing.input_control
  end

  def update_view_mode
    palletizing = Palletizing.where(id: params[:id]).update(view_mode: params[:mode])
    redirect_to palletizing_palletizing_pallets_path(palletizing)
  end

  def new
  end

  def create
    palletizing = Palletizing.create!(view_mode: params[:mode], status: :started, input_control_id: params[:input_control_id])
    redirect_to palletizing_palletizing_pallets_path(palletizing)
  end

  def update
    palletizing = Palletizing.where(id: params[:id]).update(status: :finished)
    # render inline: palletizing.inspect.html_safe
    redirect_to palletizing_palletizing_pallets_path(palletizing)
  end

  def destroy
    Palletizing.where(id: params[:id]).destroy_all
    redirect_to palletizings_path
  end

  private
  def set_palletizing
    @input_control = InputControl.where(id: params[:input_control_id]).first

    if @input_control.palletizing.present?
      redirect_to palletizing_palletizing_pallets_path(@input_control.palletizing)
    end
  end

end
