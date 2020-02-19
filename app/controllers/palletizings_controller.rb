class PalletizingsController < ApplicationController
  before_action :set_palletizing, only: [:new, :create]

  def index
    @palletizings = Palletizing.where(created_at: Date.today).or(Palletizing.where(status: :started))
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

  def show
    @palletizing = Palletizing.where(id: params[:id]).first
  end


  def new
  end

  def create
    @input_control = InputControl.where(id: params[:input_control_id]).first
    # @breakdown.errors.full_messages.each do |msg|
    #   flash[:danger] = msg
    # end
    if @input_control.pending_all?
      flash[:danger] = @input_control.pending_all
      redirect_to (sup_input_controls_path)
      return
    end
    palletizing = Palletizing.create!(view_mode: params[:mode], status: :started, input_control_id: @input_control.id, user_created_id: current_user.id, start: DateTime.now)
    redirect_to palletizing_palletizing_pallets_path(palletizing)
  end

  def update
    @palletizing = Palletizing.where(id: params[:id]).first
    @input_control = @palletizing.input_control
    result = PalletizingPallets::FinalizedService.new(@input_control, current_user).call
    if result[:success]
      flash[:success] = result[:message]
      redirect_to palletizing_palletizing_pallets_path(@palletizing)
    else
      flash[:danger] = result[:message]
      redirect_to palletizing_palletizing_pallets_path(@palletizing)
    end
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
