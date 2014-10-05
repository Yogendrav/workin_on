class Dashboard::PhotosController < ApplicationController
  def index
    if (params[:project_id].present? || params[:team_id].present? || params[:skill_id].present? || params[:start_date].present? || params[:end_date].present?)
      @events = current_company.all_events.search(params).paginate(page: params[:page], per_page: 8)
    else
      @events = current_company.all_events.paginate(page: params[:page], per_page: 8)
    end
  end

  def export
    if (params[:project_id].present? || params[:team_id].present? || params[:skill_id].present? || params[:start_date].present? || params[:end_date].present?)
      @events = current_company.all_events.search(params)
    else
      @events = current_company.all_events
    end
    temp = Tempfile.new("my-temp-filename-#{Time.now}")
    Zip::File.open(temp.path, Zip::File::CREATE) do |zipfile|
      @events.each do |event|
        if event.photo_file_name.present?
          zipfile.add(event.photo_file_name, event.photo.path)
        end
      end
    end
    send_file temp.path, :type => 'application/zip', :disposition => 'attachment', :filename => "Archive.zip"
    temp.close
  end
  def event_photo_details
    @events = current_company.all_events
    @event = Event.find(params[:event_id])
    @comment = Comment.new
    render :layout => 'photo_modal'
    if params[:email].present? && @event.update_attributes(email: params[:email]) 
      EventMailer.delay.send_event_photo(@event)
    end
  end
end