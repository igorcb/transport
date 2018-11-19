class ApplicationController < ActionController::Base
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    #devise_parameter_sanitizer.for(:account_update) << :name
  end

  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to dashboard_agent_path, flash: { danger: exception.message}
    if current_user.has_role? :admin
      redirect_to root_path, flash: { danger: exception.message }
    elsif current_user.has_role? :visit
      redirect_to dashboard_visit_path, flash: { danger: exception.message }
    elsif current_user.has_role? :client
      redirect_to dashboard_client_path, flash: { danger: exception.message }
    elsif current_user.has_role? :agent
      redirect_to dashboard_agent_path, flash: { danger: exception.message }
    elsif current_user.has_role? :oper
      redirect_to dashboard_oper_path, flash: { danger: exception.message }
    elsif current_user.has_role? :port
      redirect_to dashboard_port_path, flash: { danger: exception.message }
    else
      #root_path
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if current_user.has_role? :admin
      links_path
    elsif current_user.has_role? :visit
      dashboard_visit_path
    elsif current_user.has_role? :client
      dashboard_client_path
    elsif current_user.has_role? :agent
      dashboard_agent_path
    elsif current_user.has_role? :oper
      dashboard_oper_path
    elsif current_user.has_role? :port
      dashboard_port_path
    else
      #root_path
    end
  end

  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def print_header_pdf(report)
    @company = Company.first
    report.page.item(:image_logo).src(@company.image.path) #@company.image.url
    report.page.item(:emp_fantasia).value(@company.fantasia)
    report.page.item(:emp_razao_social).value(@company.razao_social)
    report.page.item(:emp_cnpj).value("CNPJ: " + @company.cnpj)
    report.page.item(:emp_fone).value("CONTATO: " + @company.phone_first)
    report.page.item(:emp_cidade).value(@company.cidade_estado)
  end

end
