class Worker < ActiveRecord::Base
  include AdminWorkerProcess
  
  has_and_belongs_to_many :skills
  has_many :events, ->{order(created_at: :desc)}
  has_many :tasks

  validate :minimum_number_of_skill

  delegate :name, to: :team, prefix: true, allow_nil: true

  attr_accessor :password_confirmation

  def skills_attributes=(skill_ids)
    self.skills = Skill.where(id: skill_ids)
  end

  # At login time, Check worker account active/not
  def active_for_authentication?
    super && self.active
  end

  def inactive_message
    "Sorry, this account has been disabled."
  end

  def skill_ids
    skills.pluck(:id)
  end

  def projects
    Project.where(id: project_ids)
  end

  # remove duplicate projects
  def project_ids
    events_by_projects.pluck(:project_id).uniq
  end

  def events_by_projects
    events.where(project_id: company_projects.pluck(:id)).order(created_at: :desc)
  end

  private
  def minimum_number_of_skill
    errors.add(:worker, "must have at least one skill") && false if skills.size < 1
  end

  # fetch only active projects of company
  def company_projects
    company.projects
  end
end