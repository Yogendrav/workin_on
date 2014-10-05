class TeamsController < ApplicationController
  before_action :find_team, only: [:edit, :update, :destroy]
  
  def index
    @teams = current_company.teams.includes(:workers, :company)
  end

  def new
    @team = current_company.teams.new
  end

  def edit
    @team.assign_users = @team.workers
  end

  def update
    assign_users_to_team
    if @team.update(team_params)
      redirect_to teams_path, notice: "Team successfully updated."
    else
      render :edit
    end
  end

  def create
    @team = current_company.teams.new(team_params)
    assign_users_to_team
    if @team.assign_users_valid? && @team.save
      redirect_to teams_path, notice: "Team successfully created."
    else
      render :new
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path, notice: "Team successfully deleted."
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def assign_users_to_team
    @team.assign_users = params[:assign_users][:id]
  end

  def find_team
    @team = current_company.teams.find(params[:id])
    @team.admin_team? && raise(AccessDenied, "You can't edit admin team.")
  end
end