class CompanySkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :company

  validates :skill_id, uniqueness: {scope: :company_id}, presence: true
end