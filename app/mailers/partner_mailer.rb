class PartnerMailer < ActionMailer::Base
  default from: 'support@syncrew.com'

  def partner_invitation(partner)
    @partner = partner
    mail(to: @partner.email, subject: "Partner Invitation")
  end
end