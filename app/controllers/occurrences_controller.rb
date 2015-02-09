class OccurrencesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_occurrence, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    @occurrences = Occurrence.all
    respond_with(@occurrences)
  end

  def show
    @comment = @occurrence.comments.build
    respond_with(@occurrence)
  end

  def new
    @occurrence = Occurrence.new
    respond_with(@occurrence)
  end

  def edit
  end

  def create
    @occurrence = Occurrence.new(occurrence_params)
    @occurrence.save
    respond_with(@occurrence)
  end

  def update
    @occurrence.update(occurrence_params)
    respond_with(@occurrence)
  end

  def destroy
    @occurrence.destroy
    respond_with(@occurrence)
  end

  private
    def set_occurrence
      @occurrence = Occurrence.find(params[:id])
    end

    def occurrence_params
      params.require(:occurrence).permit(:driver_id, :placa, :cte, :data)
    end
end
