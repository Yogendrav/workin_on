class AdminsController < ApplicationController
  before_action :find, only: [:edit, :update, :destroy, :password_reset, :password_update]

  def index
    # Current company admins and workers
    @users = current_company.admins | current_company.workers.includes(:skills, :team)
  end

  def destroy
    @admin.eql?(current_admin) && raise(UserOwnAccount, "You can't delete own account.")
    @admin.update(active: false) && redirect_to(admins_path, notice: "#{@admin.name.humanize} successfully deleted.")
  end

  def update
    if update_admin_email_alert_teams && @admin.update(update_params)
      redirect_to admins_path, notice: "#{@admin.name.humanize} successfully updated."
    else
      render 'edit'
    end
  end

  def password_update
    if @admin.update_with_password(password_params)
      redirect_to edit_admin_path(@admin), notice: "Password successfully updated."
    else
      render 'password_reset'
    end
  end

  private

  def update_params
    params.require(:admin).permit(:name, :email, :phone, :photo, :email_al_over_time, :email_al_late_clock_in, :email_al_late_clock_out, :email_al_away_from_project, :email_al_clock_in, :email_al_clock_out)
  end

  def password_params
    params.require(:admin).permit(:password, :password_confirmation, :current_password)
  end

  def find
    @admin = current_company.admins.find(params[:id])
  end

  def update_admin_email_alert_teams
    @admin.teams_email_alerts.destroy_all
    @admin.teams_attributes = params[:teams][:id]
  end
  
end