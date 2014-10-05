class EventMailer < ActionMailer::Base
  default from: "from@example.com"
  def send_event_photo(event)
    @event = event
    mail(to: @event.email, subject: "Worker Event Details")
  end
end
