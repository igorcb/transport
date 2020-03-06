class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html, :js

  # GET /products
  # GET /products.json
  def index
    #@products = Product.all
    @q = Product.where(id: -1).search(params[:query])
    @products = Product.includes(:category).load.order(id: :desc).limit(40)
    #respond_with(@products)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, flash: { success: "Product was successfully created." } }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, flash: { success: "Product was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def get_product_by_cod_prod
    @product = Product.where(cod_prod: params[:product_id]).first
    respond_to do |format|
      format.js
    end
  end

  def search
    @q = Product.includes(:category).search(params[:query])
    @products = @q.result
    respond_with(@products) do |format|
     format.js
    end
  end

  # def form_search_ean
  #   #code
  # end

  def search_ean
    @products = params[:ean].present? ? Product.includes(:category).where(ean: params[:ean]) : Product.where(id: -1)
    respond_with(@products)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:descricao, :category_id,
        :cod_prod, :ncm, :cest, :cfop, :ean, :ean_box, :unid_medida, :ean_trib, :unid_medida_trib, :valor_unitario,
        :cubagem, :width, :length, :height, :volume, :weight_liquid, :weight_gross, :ballast, :layer_pallet, :box_by_pallet, :factor)
    end
end
