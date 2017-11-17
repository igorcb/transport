class ConfigSystemsController < ApplicationController
  before_action :set_config_system, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @config_systems = ConfigSystem.all
    respond_with(@config_systems)
  end

  def show
    respond_with(@config_system)
  end

  def new
    @config_system = ConfigSystem.new
    respond_with(@config_system)
  end

  def edit
  end

  def create
    @config_system = ConfigSystem.new(config_system_params)
    @config_system.save
    respond_with(@config_system)
  end

  def update
    @config_system.update(config_system_params)
    respond_with(@config_system)
  end

  def destroy
    @config_system.destroy
    respond_with(@config_system)
  end

  private
    def set_config_system
      @config_system = ConfigSystem.find(params[:id])
    end

    def config_system_params
      params.require(:config_system).permit(:config_key, :config_value, :config_description)
    end
end
