class Dashboard::TeamsController < ApplicationController
  def index
    @teams = all_teams
  end

  private
  def all_teams
    current_company.team_for_workers
  end
end