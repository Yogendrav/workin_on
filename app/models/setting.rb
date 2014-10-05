class Setting < ActiveRecord::Base
  belongs_to :company

  validates :overtime_hours_day, :overtime_hours_week, :break_length, :break_time, :app_op_job_name, :gps_occurrence, :app_al_OT_occurrence, :app_al_no_clock_in_occurrence, :app_al_no_clock_out_occurrence, :app_off_site_occurrence, presence: true
end