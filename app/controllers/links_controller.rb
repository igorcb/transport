class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link, only: [:show, :edit, :update, :destroy, :update_row_order]
  load_and_authorize_resource

  # GET /links
  # GET /links.json
  def index
    #@links = Link.order(:row_order)
    @links = current_user.links.order(:row_order)
  end

  def update_row_order
    @link = Link.find(link_params[:link_id])
    @link.row_order_position = link_params[:row_order_position]
    @link.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    #@link = Link.new(link_params)
    @link = current_user.links.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, flash: { success: "Link was successfully created." } }
        format.json { render action: 'show', status: :created, location: @link }
      else
        format.html { render action: 'new' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, flash: { success: "Link was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      if params[:id].present?
        puts "parametro ID esta presente"
        link_id = params[:id]
      else
        puts "parametro ID nao exist"
        link_id = params[:link][:link_id]
      end
      puts ">>>>>>>>>>>>>>>>> Link : #{link_id} <<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      link_id = params[:id].present? ? params[:id] : params[:link][:link_id]
      @link = Link.find(link_id)

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:link_id, :url, :descricao, :row_order_position)
    end
end
