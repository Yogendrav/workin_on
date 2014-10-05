class SettingsController < ApplicationController
  before_action :find_setting, only: [:index, :edit, :update, :destroy]

  def index
    unless @setting
      redirect_to new_setting_path
    else
      redirect_to edit_setting_path(@setting)
    end
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = current_company.create_setting(setting_params)
    if @setting.save
      redirect_to settings_path, notice: 'Setting was successfully created.'
    else
      render :new
    end
  end

  def update
    if @setting.update(setting_params)
      redirect_to settings_path, notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @setting.destroy
    redirect_to settings_url, notice: 'Setting was successfully destroyed.'
  end

  private

  def find_setting
    @setting = current_company.setting
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def setting_params
    params.require(:setting).permit(:overtime_hours_day, :overtime_hours_week, :break_length, :break_time, 
      :work_start_time, :work_end_time, :work_time_tolerance, :week_start_day, :book_travel_time, :distance_tolerance, 
      :app_al_breaks, :app_al_schedule, :app_al_OT, :app_al_no_clock_in, :app_al_no_clock_out, :app_off_site, :no_clock_in_int, 
      :no_clock_out_int, :adm_al_Overtime, :no_clock_in, :late_clock_in, :late_clock_out, :adm_al_away_site, 
      :app_op_job_id, :app_op_notes, :app_op_flag, :app_op_recpt, :app_op_sched, :app_op_job_name, :company_id, :gps_check, :gps_occurrence, 
      :app_al_OT_occurrence, :app_al_no_clock_in_occurrence, :app_al_no_clock_out_occurrence, :app_off_site_occurrence)
  end
  
end