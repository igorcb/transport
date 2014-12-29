class GroupClientsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_group_client, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /group_clients
  # GET /group_clients.json
  def index
    @group_clients = GroupClient.all
  end

  # GET /group_clients/1
  # GET /group_clients/1.json
  def show
  end

  # GET /group_clients/new
  def new
    @group_client = GroupClient.new
  end

  # GET /group_clients/1/edit
  def edit
  end

  # POST /group_clients
  # POST /group_clients.json
  def create
    @group_client = GroupClient.new(group_client_params)

    respond_to do |format|
      if @group_client.save                               
        format.html { redirect_to @group_client, flash: { success: "Group client was successfully created." } }
        format.json { render action: 'show', status: :created, location: @group_client }
      else
        format.html { render action: 'new' }
        format.json { render json: @group_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_clients/1
  # PATCH/PUT /group_clients/1.json
  def update
    respond_to do |format|
      if @group_client.update(group_client_params) 
        format.html { redirect_to @group_client, flash: { success: "Group client was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_clients/1
  # DELETE /group_clients/1.json
  def destroy
    @group_client.destroy
    respond_to do |format|
      format.html { redirect_to group_clients_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_client
      @group_client = GroupClient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_client_params
      params.require(:group_client).permit(:descricao)
    end
end
