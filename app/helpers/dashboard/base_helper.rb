module Dashboard::BaseHelper
  def two_days_ago_events(worker)
    # worker.events.where("created_at>=?", 2.days.ago)
    # this code for temp. because we need data for test
    worker.events.where("created_at>=?", 2.days.ago)
  end

  def short_activity(events)
    day_wise = Event.new.calculate_worked_ot_late(events)
    row = content_tag :tr, content_tag(:th, "In Hours")
    row += content_tag :tr, content_tag(:td, "#{day_wise[:worked_time].round(2)} worked")
    row += content_tag :tr, content_tag(:td, "#{day_wise[:ot_time].round(2)} OT")
    row += content_tag :tr, content_tag(:td, "#{day_wise[:late_time].round(2)} late")
    row
  end

  def message_errors(msg_obj)
    err_msg = ""
    content_tag(:ul, msg_obj.errors.full_messages.map{|msg| err_msg += content_tag(:li, msg)}[0].html_safe)
  end

  def events_locations(worker_events)
    if worker_events.is_a?(Event::ActiveRecord_AssociationRelation)
      worker_events.map{|event| event.location if event.location.present?}.compact
    else
      [worker_events.location]
    end
  end

  def worker_skills(worker)
    skills =""
    worker.skills.pluck(:name).each{|skill_name| skills += content_tag :li, skill_name.humanize}
    content_tag :ul, skills.html_safe, style: "list-style:none;"
  end

  def worker_projects(worker)
    projects =""
    worker.projects.pluck(:name).each{|project_name| projects += content_tag :li, project_name.humanize}
    content_tag :ul, projects.html_safe, style: "list-style:none;"
  end

  def day_name(date)
    date.to_date.strftime("%A")
  end

  def select_project
    current_company.projects.pluck(:name, :id)
  end
  
  def select_team
    current_company.teams.where.not(name: 'admins').pluck(:name, :id)
  end
  
  def select_skill
    current_company.skills.pluck(:name, :id)
  end
  
  def event_type_records
    EventType.pluck(:name, :id)
  end
  
  def event_type_clock_in
    EventType.where(name: 'clock_in').first.id
  end

  def event_type_clock_out
    EventType.where(name: 'clock_out').first.id
  end
  def project_location(project)
    project.address
  end
end