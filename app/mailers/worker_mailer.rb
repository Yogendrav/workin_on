class WorkerMailer < ActionMailer::Base
  default from: 'support@syncrew.com'

  # Worker details
  def send_info(worker)
    set_worker_and_mail(worker)
  end

  # Password reset details
  def password_reset(worker)
    set_worker_and_mail(worker, "Your password change information")
  end

  private

  def set_worker_and_mail(worker, subject = nil)
    @worker = worker
    mail(to: worker.email, subject: subject)
  end

end