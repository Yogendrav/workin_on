class ProjectsController < ApplicationController
  before_action :find_project, only: [:edit, :update, :destroy]

  def index
    @projects = current_company_projects
  end

  def new
    @project = current_company_projects.build
  end

  def create
    @project = current_company_projects.build(project_params)
    if @project.save
      redirect_to projects_path, notice: "#{@project.name.humanize} successfully created."
    else
      render 'new'
    end
  end

  def update
    if @project.update(update_params)
      redirect_to projects_path, notice: "#{@project.name.humanize} successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @project.update(active: false)
    redirect_to projects_path, notice: "#{@project.name.humanize} successfully deleted"
  end

  def address_map
    # @project = current_company.projects.find(params[:project_id])
  end

  def project_share
    @partners = current_company.partners
  end

  def share
    project_share = current_company.project_shares.build(share_params)
    if project_share.save
      ProjectMailer.delay.project_partner_invitation(project_share)
      redirect_to project_share_projects_path(project_id: params[:project_id])
    else
      redirect_to project_share_projects_path(project_id: params[:project_id])
    end
  end

  def destroy_project_shared
    project_share = current_company.project_shares.find(params[:project_share_id])
    project_share.destroy
    redirect_to project_share_projects_path(project_id: params[:project_id])
  end

  private

  def project_params
    params.require(:project).permit(:company_id, :name, :active_radius, :active, :address, :address_latt, :address_long)
  end

  def update_params
    params[:project].delete(:id)
    params.require(:project).permit(:name, :active_radius, :active, :address, :address_latt, :address_long)
  end

  def share_params
    params.permit(:subcontractor_id, :project_id)
  end
  
  def current_company_projects
    current_company.projects.includes(:company)
  end

  def find_project
    @project = current_company_projects.find(params[:id])
  end
end
