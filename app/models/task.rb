class Task < ActiveRecord::Base
  # set scheduler base on task's updated_at field such as next days value set 2 that means msg goes (updated_at+2.days)
  # same for other fields if they are true, then take that updated_at and base on that set scheduler time
  belongs_to :worker
  belongs_to :project
  belongs_to :company

  validates :worker_id, :project_id, :company_id, presence: true
  validate :check_duration_or_end_date?, :check_copy_to_fields?

  attr_accessor :copy_to_type

  def check_duration_or_end_date?
    duration_exist? || self.end_date.present? || self.errors.add(:base, "Please provide 'duration' or 'end date'.")
  end

  def check_copy_to_fields?
    self.next_days != 0 || self.every_day_this_week || self.same_weekday_each_week ||
      self.every_day_this_month || self.errors.add(:base, "Must select atleast one copy to fields.")
  end

  def scheduled_events
  {
    title: self.project.name.humanize+" - "+self.worker.skills.first.name.humanize,
    start: self.updated_at.strftime("%Y/%m/%d %H:%M"),
    end: end_time.strftime("%Y/%m/%d %H:%M"),
    allDay: false
  }
  end

  def duration_in_time
    {hour: self.duration.hour, minutes: self.duration.min}
  end

  def duration_exist?
    self.duration.hour != 0 || self.duration.min != 0
  end

  def end_time
    duration_exist? && (self.updated_at + (duration_in_time[:hour].hour + duration_in_time[:minutes].minute)) || self.updated_at
  end
  # need discussion on that part
  # calculattion for handle events on calendar
  def end_date_check
    event_occurence_for_end_date
  end

  def event_occurence?
    num_of_days = if next_days.non_zero?
      next_days
    elsif every_day_this_week
      # here need to calculate sat and sun include in calendar schedule
      7
    elsif same_weekday_each_week
      # need to calculate current month's, every week's weekday
      4
    else
      # need to calculate how much days still left in current month, then add schedule
      30
    end
    add_event_occurence(num_of_days)
  end

  def add_event_occurence(num_of_days)
    num_of_days.times do |n|
    {
      title: self.project.name.humanize+" - "+self.worker.skills.first.name.humanize,
      start: (self.updated_at + n.day).strftime("%Y/%m/%d %H:%M"),
      end: duration_or_end_date.strftime("%Y/%m/%d %H:%M"),
      allDay: false
    }
    end
  end

  def event_occurence_for_end_date
    if self.end_date && self.end_date > self.updated_at
      num_of_days = (self.end_date - self.updated_at)/(24*3600)
      add_event_occurence(num_of_days)
    end
  end
end