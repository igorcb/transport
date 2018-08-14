class OccurrencesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_occurrence, only: [:show]
  load_and_authorize_resource

  respond_to :html

  def index
    @occurrences = Occurrence.order(date_occurrence: :desc)
    respond_with(@occurrences)
  end

  def show
    respond_with(@occurrence)
  end

  private
    def set_occurrence
      @occurrence = Occurrence.find(params[:id])
    end

end
