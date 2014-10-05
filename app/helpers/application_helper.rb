module ApplicationHelper

  def title(page_title)
    content_for(:title, page_title)
  end

  def error_notifications(error)
    notification = case error.keys[0]
      when "error", "alert" then notification_content("danger", error[error.keys[0]])
      when "warning" then notification_content("warning", error[error.keys[0]])
      when "notice" then notification_content("success", error[error.keys[0]])
      else ""
    end
    notification
  end

  def notification_content(type, message)
    "<div class='alert alert-#{type} alert-dismissible' role='alert'>"+
      "<button type='button' class='close' data-dismiss='alert'>"+
        "<span aria-hidden='true'>&times;</span>"+
        "<span class='sr-only'>Close</span>"+
      "</button>"+
      "#{message}"+
    "</div>".to_s
  end
  
  def set_timepicker_time(datetime)
    datetime.strftime("%I:%M %p")
  end
end