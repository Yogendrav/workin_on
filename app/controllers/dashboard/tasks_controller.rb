class Dashboard::TasksController < ApplicationController
  before_action :find_worker, only: [:new, :create, :calendar_events]

  def new
    @task = @worker.tasks.new(company_id: @worker.company_id)
  end

  def create
    set_copy_to_attributes
    @task = @worker.tasks.new(create_params)
    if @task.save
      redirect_to dashboard_worker_calendar_path(@worker, params[:date]), notice: "Task successfully scheduled."
    else
      render :new, with: {date: params[:date]}
    end
  end

  def calendar_events
    @tasks = @worker.tasks.includes(:project).map(&:scheduled_events)
    render json: @tasks
  end

  private
  def find_worker
    @worker = current_company.workers.find(params[:worker_id])
  end

  def create_params
    params.require(:task).permit(:worker_id, :project_id, :company_id, :duration, :end_date, :next_days,
      :every_day_this_week, :same_weekday_each_week, :every_day_this_month)
  end

  def set_copy_to_attributes
    params[:task][:end_date].present? && convert_date
    unless params[:task][:copy_to_type].eql?("next_days")
      params[:task].merge!(params[:task][:copy_to_type] => true)
      params[:task].delete(:next_days)
    end
    params[:task].delete(:copy_to_type)
  end

  def convert_date
    date = params[:task][:end_date].split("/")
    date = date[2]+"/"+date[0]+"/"+date[1]
    params[:task][:end_date] = date.to_date
  end
end