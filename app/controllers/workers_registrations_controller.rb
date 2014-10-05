class WorkersRegistrationsController < Devise::RegistrationsController
  include WorkerAdminProcess

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << (BASE_PARAMETERS | [:tolerance, :working_hrs_start, :working_hrs_end])
  end
  
end