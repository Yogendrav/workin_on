class Company < ActiveRecord::Base
  belongs_to  :primary_contact, class_name: 'Admin'
  has_one :setting
  has_many :admins, ->{ where(active: true).order(name: :asc) }
  has_many :teams, ->{ order(name: :asc) }
  has_many :workers, ->{ where(active: true).order(name: :asc) }
  has_many :projects, ->{ where(active: true).order(name: :asc) }
  has_many :company_skills
  has_many :skills, through: :company_skills
  has_many :partners
  has_many :project_shares
  has_many :tasks
  
  validates :name, presence: true
  
  def teams_except_admins
    teams.where.not(name: "admins").pluck(:name, :id)
  end

  def all_teams_except_admins_and_default
    teams.where("name != 'admins' and name!='default'")
  end

  def admins_team
    team_by_name('admins')
  end

  def default_team
    team_by_name('default')
  end

  def worker_with_team_name_list
    workers.includes(:team).map{|worker| Worker.new({name: worker.name+"(#{worker.team.name})", id: worker.id})}
  end

  def team_for_workers
    teams.includes(workers: {events: [:event_type, :project, :worker]}).where.not(name: "admins")
  end

  def all_events
    Event.where(project_id: self.projects.pluck(:id))
  end

  def self.all_except(company)
    where.not(id: company)
  end

  private
  def team_by_name(team_name)
    teams.where(name: team_name).take
  end
  
end