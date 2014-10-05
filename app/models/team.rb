class Team < ActiveRecord::Base
  belongs_to :company
  has_many :workers, ->{where(active: true)}
  has_and_belongs_to_many :admins_email_alerts, class_name: 'Admin', join_table: :admins_teams_email_alerts

  validates :name, uniqueness: {scope: :company_id}, presence: true

  attr_accessor :assign_users

  after_save :assign_teams_to_worker
  before_destroy :check_defaults_teams, :move_workers_to_default_team

  def admins
    self.company.admins
  end

  def members_size
    team_members.size
  end

  def members_list
    team_members.pluck(:name, :id)
  end

  def assign_users_valid?
    check_assign_teams
  end

  def assign_teams_to_worker
    Worker.where(id: assign_users).update_all(team_id: self.id)  
  end

  def admin_team?
    name == "admins"
  end

  def self.all_except(team)
    where.not(name: "admins")
  end

  private

  def team_members
    Worker.where(team_id: self.id, company_id: self.company_id)
  end

  # Check there is not more then one company
  def check_assign_teams
    workers = Worker.where(id: assign_users)
    if workers.pluck(:company_id).uniq.size > 1
      errors.add(:worker, "not part of this company.") && false
    else
      true
    end
  end

  def check_defaults_teams
    if ["admins", "default"].include?(self.name.downcase)
      errors.add(:teams, "admins and default can't be delete.") && false
    end
  end

  def move_workers_to_default_team
    self.workers.update_all(team_id: self.company.default_team.id)
  end
  
end