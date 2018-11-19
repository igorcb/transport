class SegmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_segment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @segments = Segment.all
    respond_with(@segments)

    segment_hash = {}
    @segments.each do |segment|
      segment_hash.store(segment, {id: segment.id, name: segment.name})
    end
       #data = {logradouro: address[:address], bairro: address[:neighborhood], localidade: address[:city], uf: address[:state], cep: address[:zipcode]}

  end

  def show
    respond_with(@segment)
  end

  def new
    @segment = Segment.new
    respond_with(@segment)
  end

  def edit
  end

  def create
    @segment = Segment.new(segment_params)
    respond_to do |format|
      if @segment.save
        format.html { redirect_to @segment, flash: { success: "segment was successfully created." } }
        format.json { render action: 'show', status: :created, location: @segment }
      else
        format.html { render action: 'new' }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @segment.update(segment_params)
        format.html { redirect_to @segment, flash: { success: 'segment was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @segment.destroy
    respond_with(@segment)
  end

  private
    def set_segment
      @segment = Segment.find(params[:id])
    end

    def segment_params
      params.require(:segment).permit(:name)
    end
end
