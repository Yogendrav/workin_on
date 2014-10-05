class Dashboard::CalendarsController < ApplicationController
  def search
  	# complete show events funtionality on calendar
  	@task = Task.where("project_id= ? or skill_id= ? or team_id=?", params[:project_id], params[:skill_id], params[:team_id])
  end
end
