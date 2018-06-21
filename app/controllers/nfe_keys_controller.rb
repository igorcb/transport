class NfeKeysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_nfe_key, only: [:edit, :update, :edit_action_inspector, :update_action_inspector]
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
      if @nfe_key.update(nfe_key_params)
        format.html { redirect_to action_inspectors_path, flash: { success: "Confirm DAE was successfully updated." } }
      else
        format.html { render action: 'edit' }
      end
    end
  end  

  def search
    @q = NfeKey.where(nfe_source_type: "InputControl").paginate(:page => params[:page]).search(params[:query])
    @nfe_keys = @q.result
    respond_with(@nfe_keys) do |format|
     format.js
    end
  end

  private
    def set_nfe_key
      @nfe_key = NfeKey.find(params[:id])
    end

    def nfe_key_params
      params.require(:nfe_key).permit(:asset, :action_inspector)
    end
end
