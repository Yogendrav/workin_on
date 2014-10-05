class Admin < ActiveRecord::Base
  include AdminWorkerProcess

  has_and_belongs_to_many :teams_email_alerts, class_name: 'Team', join_table: :admins_teams_email_alerts
  # has_and_belongs_to_many :events_editor_users, class: 'Evnet', join_table: :events_editor_users
  has_many :comments
  def teams_attributes=(attribs)
    self.teams_email_alerts << Team.where(id: attribs)
  end

  def company_admins_team_id
    company.admins_team.id
  end

  def company_default_team_id
    company.default_team.id
  end

  # At login time, Check admin account active/not
  def active_for_authentication?
    super && self.active
  end

  def inactive_message
    "Sorry, this account has been disabled."
  end
  
end