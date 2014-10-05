class Dashboard::WorkersController < ApplicationController
  before_action :find_worker, only: [:show, :activity, :send_message, :location_map,
    :timesheet_events, :filter_timesheet_events, :calendar]
  before_action :worker_events, only: [:show]
  before_action :events_by_date, only: [:activity, :location_map, :filter_timesheet_events]
  before_action :find_worker_event, only: [:edit_events_timesheet, :update_events_timesheet]

  def send_message
    @message = current_admin.messages.new(message_params)
    @status = @message.save
    render :message_status
  end

  ###################################
  ###### Woreder Event store method #
  def worker_event_new_page
    find_worker
    @event = @worker.events.build
  end

  def worker_event_create_page
    params[:worker_id] = params[:event][:worker_id]
    find_worker
    event_params = params.require(:event).permit(:project_id, :worker_id, :skill_id, :flag, :receipt, :location, :event_type_id, :photo)
    @event = @worker.events.new(event_params)
    if @event.save
      redirect_to dashboard_worker_event_new_page_path(@worker), notice: "Event created."
    else
      render :worker_event_new_page
    end
  end
  ##################################

  def filter_timesheet_events
    if params[:project]
      conditions = []
      query = "date_format(created_at, '%Y-%m-%d') >= ? and date_format(created_at, '%Y-%m-%d') <= ?"
      params[:project].empty? ? conditions << query : conditions << ("project_id = ? and "+ query) << params[:project]
      conditions << params[:start_date] << params[:end_date]
      @events = @worker.events.includes(:event_type, :project).where(conditions).paginate(page: params[:page], per_page: 10)
    end
  end

  def update_events_timesheet
    if @event.update(timesheet_update_param)
      redirect_to dashboard_worker_edit_events_timesheet_path(@worker, @event), notice: "Timesheet successfully updated."
    else
      render :edit_events_timesheet
    end
  end

  private
  def find_worker
    @worker = current_company.workers.find(params[:id] || params[:worker_id])
  end

  def message_params
    params.require(:message).permit(:worker_id, :admin_id, :notes).merge!(worker_id: params[:worker_id])
  end

  # this is for worker's event photo
  def worker_events
    @events = @worker.events.includes(:worker).paginate(page: params[:page], per_page: 8)
  end

  def events_by_date
    conditions = ""
    unless params[:project]
      @events = if params[:action].eql?("location_map") || params[:day_type].eql?("yesterday")
        conditions = "date_format(created_at, '%Y-%m-%d') = ?"
        @worker.events
      else
        conditions = "date_format(created_at, '%Y-%m-%d') >= ?"
        @worker.events.includes(:project, :event_type)
      end.where(conditions, params[:date] || Date.today).paginate(page: params[:page], per_page: 10)
    end
  end

  def find_worker_event
    @event = find_worker.events.find(params[:event_id])
  end

  def timesheet_update_param
    params.require(:event).permit(:created_at, :project_id)
  end
end