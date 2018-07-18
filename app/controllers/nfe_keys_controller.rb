class NfeKeysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_nfe_key, only: [:show, :edit, :update, :edit_action_inspector, :update_action_inspector, :update_pending]
  load_and_authorize_resource
  respond_to :html, :js, :json

  def get_nfe_keys_by_boarding
    @boarding = Boarding.joins(:nfe_keys).where(id: params[:boarding_id], nfe_keys: {nfe: params[:nfe_id]}).first
    respond_to do |format|
      format.js
    end
  end

  def index
    @q = NfeKey.where(id: -1).paginate(:page => params[:page]).search(params[:query])
    @nfe_keys = NfeKey.all.paginate(:page => params[:page])
    respond_with(@nfe_keys)
  end

  def show

  end

  def edit
  end

  def update
    respond_to do |format|
      if @nfe_key.update(nfe_key_params)
        format.html { redirect_to nfe_keys_path, flash: { success: "AccountReceivable was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'index', status: :created, location: @nfe_key }
      else
        format.html { render action: 'edit' }
        format.json { render json: @nfe_key.errors, status: :unprocessable_entity }
        format.js   { render json: @nfe_key.errors, status: :unprocessable_entity }
      end
    end  	
  end

  def edit_action_inspector
  end

  def update_action_inspector
    respond_to do |format|
      @nfe_key.action_inspector_user_confirmed_id = current_user.id
      @nfe_key.action_inspector_updated_confirmed = Time.current
      if @nfe_key.update(nfe_key_params)
        format.html { redirect_to action_inspectors_path, flash: { success: "Confirm DAE was successfully updated." } }
      else
        format.html { render action: 'edit' }
      end
    end
  end  

  def search
    if params[:status].to_i == NfeKey::TypeTakeDae::ABERTO
      @q = NfeKey.where(nfe_source_type: "InputControl", take_dae: true, action_inspector_file_name: nil).paginate(:page => params[:page]).search(params[:query])
    elsif params[:status].to_i == NfeKey::TypeTakeDae::PAGO
      @q = NfeKey.where(nfe_source_type: "InputControl", take_dae: true).where.not(action_inspector_file_name: nil).paginate(:page => params[:page]).search(params[:query])
    else
      @q = NfeKey.where(nfe_source_type: "InputControl").paginate(:page => params[:page]).search(params[:query])
    end

    @nfe_keys = @q.result
    respond_with(@nfe_keys) do |format|
     format.js
    end
  end

  def pending
    @nfe_key = NfeKey.find(params[:id])
  end

  def update_pending
    @nfe_key.retained = NfeKey::Retained::SIM
    @nfe_key.retained_created_user_id = current_user.id
    respond_to do |format|
      if @nfe_key.update(nfe_key_params)
        format.html { redirect_to nfe_keys_path, flash: { success: "Pending was successfully updated." } }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def request_receipt
    if @nfe_key.ordem_service.client.emails.type_sector(Sector::TypeSector::FINANCEIRO).pluck(:email).blank?
      flash[:danger] = "Could not request declaration. Make sure the customer has an email with the FINANCIAL sector."
      redirect_to nfe_keys_path
      return
    end      
    respond_to do |format|
      NfeKeyMailer.request_receipt(@nfe_key).deliver!
      format.html { redirect_to nfe_keys_path, flash: { success: "Request Receipt was successfully updated." } }
    end
  end

  def request_payment_dae
    if !@nfe_key.take_dae?
      flash[:danger] = "Can not send DAE charge, take_dae is false"
      redirect_to @nfe_key
      return
    elsif @nfe_key.action_inspector_file_name.present?
      flash[:danger] = "NF-e already has payment_dae"
      redirect_to @nfe_key
      return
    elsif @nfe_key.ordem_service.client.emails.type_sector(Sector::TypeSector::FINANCEIRO).pluck(:email).blank?
      flash[:danger] = "Could not request declaration. Make sure the customer has an email with the FINANCIAL sector."
      redirect_to @nfe_key
      return
    end      
    respond_to do |format|
      NfeKeyMailer.request_payment_dae(@nfe_key).deliver!
      format.html { redirect_to @nfe_key, flash: { success: "Request Payment DAE was successfully updated." } }
    end
  end  

  def take_dae

  end

  def update_take_dae
    if params[:nfe_key][:action_inspector_number].blank?
      flash[:danger] = "Action Inspector can not be blank"
      #render action: 'take_dae'
      redirect_to take_dae_nfe_key_path(@nfe_key)
      return
    elsif @nfe_key.take_dae?
      flash[:danger] = "Can not DAE charge, take_dae is true"
      redirect_to @nfe_key
      return
    end
      
    respond_to do |format|
      if @nfe_key.update(nfe_key_params)
        NfeKey.take_dae(@nfe_key)
        format.html { redirect_to @nfe_key, flash: { success: "Take DAE was successfully updated." } }
      else
        format.html { render action: 'take_dae' }
      end
    end
  end


  private
    def set_nfe_key
      @nfe_key = NfeKey.find(params[:id])
    end

    def nfe_key_params
      params.require(:nfe_key).permit(:asset, :action_inspector, :action_inspector_number, :motive_id, :motive_observation)
    end

end
