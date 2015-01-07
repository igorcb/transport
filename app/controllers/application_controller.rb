class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    #devise_parameter_sanitizer.for(:account_update) << :name
  end

  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to dashboard_agent_path, flash: { danger: exception.message}
    if current_user.has_role? :admin
      redirect_to root_path, flash: { danger: exception.message }
    elsif current_user.has_role? :visit
      redirect_to dashboard_visit_path, flash: { danger: exception.message }
    else  
      redirect_to dashboard_agent_path, flash: { danger: exception.message }
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if current_user.has_role? :admin
      links_path
    elsif current_user.has_role? :visit
      dashboard_visit_path
    else  
      dashboard_agent_path
    end
  end

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end  
  
end
