class Dashboard::ProjectsController < ApplicationController
  def index
    @project = Project.first
    @events = current_company.all_events
  end
  def activity
    @project = Project.find(params[:project_id])
    @events = current_company.all_events
  end
end