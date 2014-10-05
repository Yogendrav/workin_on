class Event < ActiveRecord::Base
  belongs_to :project
  belongs_to :skill
  belongs_to :worker
  belongs_to :event_type
  has_many :comments
  # has_and_belongs_to_many :events_editor_users, class: 'Admin', join_table: :events_editor_users

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
  validates :project_id, :skill_id, :worker_id, :event_type_id, :location, :photo, presence: true, on: :create
  validates :project_id, presence: true, on: :update

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" },
    url: '/system/:class/:id/:style/:normalized_photo_name',
    path: ":rails_root/public/system/:class/:id/:style/:normalized_photo_name",
    default_url: "event_missing.png"

  validates_attachment_content_type :photo, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, message: 'type is not allowed (only jpeg/png/gif images allowed)'

  Paperclip.interpolates :normalized_photo_name do |attachment, style|
    attachment.instance.normalized_photo_file_name
  end

  def normalized_photo_file_name
    transliterate(self.photo_file_name)
  end

  ###### Calculate worked, ot and late time of worker ########
  def calculate_worked_ot_late(events)
    total_worked_ot_lat = {worked_time: 0, ot_time: 0, late_time: 0}
    events_dates = events.map{|event| event.created_at.strftime('%Y-%m-%d')}.uniq

    if events_dates.size > 1
      events_dates.each do |event_date|
        day_wise_events = events.where("date_format(created_at, '%Y-%m-%d') = ?", event_date)
        day_wise = by_day(day_wise_events)
        total_worked_ot_lat[:worked_time] += day_wise[:worked_time]
        total_worked_ot_lat[:ot_time] += day_wise[:ot_time]
        total_worked_ot_lat[:late_time] += day_wise[:late_time]
      end
    else
      total_worked_ot_lat = by_day(events)
    end
    total_worked_ot_lat
  end

  def by_day(events)
    clock_in_sec = break_start_sec = break_end_sec = clock_out_sec = 0
    worker = events.first.worker

    events.each do |event|
      case event.event_type.name
        when "clock in"
          clock_in_sec = fetch_seconds(event.created_at)
        when "start break"
          break_start_sec += fetch_seconds(event.created_at)
        when "end break"
          break_end_sec += fetch_seconds(event.created_at)
        when "clock out"
          clock_out_sec = fetch_seconds(event.created_at)
      end
    end
    
    # if worker still working and not clock out, then use Time.now as a clock out for further calculation
    # such as worked, how much time worker consume yet.
    clock_out_sec = clock_out_sec.zero? ? fetch_seconds(Time.now) : clock_out_sec
    worked = (clock_out_sec - clock_in_sec) - (break_end_sec - break_start_sec)
    cwws = calculate_worker_work_sec(worker, clock_in_sec)
    cos_wes_diff = clock_out_sec - cwws[:work_end_sec]
    ot = cos_wes_diff > 0 ? cos_wes_diff : 0
    Hash[worked_time: worked/3600.0, ot_time: ot/3600.0, late_time: cwws[:total_late_sec]/3600.0]
  end

  def calculate_worker_work_sec(worker, clock_in_sec)
    work_start_sec = fetch_seconds(worker.working_hrs_start)
    work_end_sec = fetch_seconds(worker.working_hrs_end)
    cis_wss_diff = clock_in_sec - work_start_sec

    if cis_wss_diff > 0
      work_tolerance_sec = (worker.tolerance.zero? ? worker.company.setting.tolerance : worker.tolerance) * 60
      total_late_sec = cis_wss_diff > work_tolerance_sec ? (cis_wss_diff - work_tolerance_sec) : 0
    else
      total_late_sec = 0
    end
    Hash[work_start_sec: work_start_sec, work_end_sec: work_end_sec, total_late_sec: total_late_sec]
  end

  def fetch_seconds(datetime)
    (datetime.hour * 3600) + (datetime.min * 60) + (datetime.sec)
  end

  private
  def transliterate(str)
    str.downcase!
    str.gsub!(/'/, '')
    str.gsub!(/[^A-Za-z0-9_\.]+/, ' ')
    str.strip!
    str.gsub!(/\ +/, '-')
    str
  end
 
  def self.search(params)
    result = self.all
    result = result.where(project_id: params[:project_id]) if params[:project_id].present?
    result = result.where(worker_id: Worker.where(team_id: params[:team_id]).map {|worker| worker.id}) if params[:team_id].present?
    result = result.where(skill_id: params[:skill_id]) if params[:skill_id].present?
    result = result.where("date_format(created_at, '%m/%d/%y') >= '#{params[:start_date]}' and date_format(created_at, '%m/%d/%y') <= '#{params[:end_date]}'") 
    result = result.where(flag: true) if (params[:event] and params[:event][:flag] == "1")
    result = result.where(receipt: true) if (params[:event] and params[:event][:receipt] == "1")
    result = result.where(event_type_id: params[:event_type]) if ( params[:event_type] and params[:event_type].present?)
    result
  end
end