class NfeKeysController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :js, :json

  def get_nfe_keys_by_boarding
    @boarding = Boarding.joins(:nfe_keys).where(id: params[:boarding_id], nfe_keys: {nfe: params[:nfe_id]}).first
    respond_to do |format|
      format.js
    end
  end

  def index
    @q = NfeKey.where(id: -1).search(params[:query])
    @nfe_keys = NfeKey.where(id: -1)
    respond_with(@nfe_keys)
  end

  def search
    @q = NfeKey.where(nfe_source_type: "InputControl").search(params[:query])
    @nfe_keys = @q.result
    respond_with(@nfe_keys) do |format|
     format.js
    end
  end
end
