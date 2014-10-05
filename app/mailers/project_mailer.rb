class ProjectMailer < ActionMailer::Base
  default from: 'support@syncrew.com'
  def project_partner_invitation(project_share)
    @project_share = project_share
    mail(to: project_share.subcontractor.company.email, subject: "Project Shared")
  end
end
