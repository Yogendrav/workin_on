class SkillsController < ApplicationController

  def index
    @selected_skill = current_company.skills.pluck(:id)
    @selected_skill.blank? && redirect_to(new_skill_path)
    @company = current_company
  end
  
  def new
    @skill = Skill.new
  end
  
  def create
    if current_company.skills << Skill.where(id: params[:skill][:id])
      redirect_to skills_path, notice: "Company skills successfully created."
    else
      render 'new'
    end
  end

  def update
    current_company.skills.destroy_all
    current_company.skills << Skill.where(id: params[:company][:id])
    redirect_to skills_path, notice: "Company skills successfully updated."
  end

  private

  def skill_params
    params.require(:skill).permit(:name)
  end
  
end
