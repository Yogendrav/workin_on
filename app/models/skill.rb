class Skill < ActiveRecord::Base
  has_many :company_skills
  has_many :companies, through: :company_skills
  has_and_belongs_to_many :workers
  has_many :events

  validates :name, uniqueness: true
end
