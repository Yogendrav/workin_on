module WorkerAdminProcess
  extend ActiveSupport::Concern

  BASE_PARAMETERS = [:name, :phone, :company_id, :photo, :team_id]

  included do
    prepend_before_filter :require_no_authentication, except: [ :new, :create], if: :admin_signed_in?
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  # Override devise create method for Admin and Worker
  def create
    build_resource(sign_up_params)
    resource_name.to_s.eql?("worker") && set_attributes_for_worker
    resource_name.to_s.eql?("admin") && set_teams_attributes_for_admin
    resource_saved = resource.save
    yield resource if block_given?

    if resource_saved
      redirect_to admins_path, notice: "#{resource.name.humanize} as #{resource_name.to_s} successfully registered."
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      @minimum_password_length = resource_class.password_length.min if @validatable
      respond_with resource
    end
  end

  private
  def set_attributes_for_worker
    resource.skills_attributes =  params[:skills]
  end

  def set_teams_attributes_for_admin
    resource.teams_attributes =  params[:teams][:id]
  end
end