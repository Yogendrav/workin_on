module SkillsHelper

  def selected_skills
    @skill = Skill.all
  end

  def select_company_skills
    @skill = Skill.pluck(:name, :id)
  end
  
end