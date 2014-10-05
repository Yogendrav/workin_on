class RegistrationsController < Devise::RegistrationsController
  include WorkerAdminProcess

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << (BASE_PARAMETERS | [:super_admin, :email_al_over_time, :email_al_late_clock_in, :email_al_late_clock_out,
        :email_al_away_from_project ,:email_al_clock_in ,:email_al_clock_out])
  end
end