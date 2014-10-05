class WorkersController < ApplicationController
  before_action :find_worker, only: [:edit, :update, :destroy, :send_info, :password_reset, :password_update]

  def update
    if update_worker_skills && @worker.update(update_params)
      redirect_to admins_path, notice: "#{@worker.name.humanize} worker successfully updated."
    else
      render :edit
    end
  end

  # Soft delete worker
  def destroy
    @worker.update(active: false) && redirect_to(admins_path, notice: "#{@worker.name.humanize} successfully deleted.")
  end

  # Send worker information to worker
  def send_info
    WorkerMailer.send_info(@worker).deliver
    redirect_to admins_path, notice: "Worker information has been successfully sent."
  end
  
  def password_update
    if @worker.update(password_params)
      WorkerMailer.password_reset(@worker).deliver
      redirect_to edit_worker_path(@worker), notice: "#{@worker.name.humanize} password successfully changed."
    else
      render :password_reset
    end
  end

  private

  def find_worker
    @worker = current_company.workers.find(params[:id])
  end

  def update_params
    params.require(:worker).permit(:name, :email, :phone, :company_id, :photo, :team_id, :tolerance, :working_hrs_start, :working_hrs_end)
  end

  def password_params
    params.require(:worker).permit(:password, :password_confirmation)
  end

  def update_worker_skills
    @worker.skills.destroy_all
    @worker.skills_attributes = params[:skills]
  end
end