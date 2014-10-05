class CompaniesController < ApplicationController
  before_action :find_company, only: [:index, :update]

  def update
    if @company.update(update_params)
      redirect_to :back, notice: "#{@company.name.humanize} successfully updated."
    else
      render :index
    end
  end

  private

  def find_company
    @company = current_company
  end

  def update_params
    params.require(:company).permit(:name, :primary_contact_id)
  end

end