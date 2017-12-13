class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update]

  respond_to :html

  def show
    respond_with(@company)
  end

  def edit
  end

  def update
    @company.update(company_params)
    respond_with(@company)
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:cnpj, :razao_social, :fantasia, :inscricao_estadual, :inscricao_municipal, :endereco, :numero, :complemento, :bairro, :cidade, :estado, :cep, :pais, :phone_first, :phone_second, :observacao, :image, :quitter)
    end
end
