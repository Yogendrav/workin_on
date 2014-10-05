class PartnersController < ApplicationController
  def index
    @partners = current_company.partners
  end

  def new
    @partner = current_company.partners.build
  end

  def create
    @partner = current_company.partners.new(partner_params)
    if current_admin.email != @partner.email
      if @partner.save
        PartnerMailer.delay.partner_invitation(@partner)
        redirect_to partners_path, notice: "Invitation sent successfully."
      else
        render "new"
      end
    else
      redirect_to new_partner_path, notice: "You can not become a partner with your email."
    end
  end

  def destroy
    @partner = current_company.partners.find(params[:id])
    @partner.destroy
    redirect_to partners_path
  end

  def accept_invitation
    partner = Partner.where(token: params[:token], subcontractor_id: current_admin.id).take
    if partner
      partner.update!(status: true)
      redirect_to root_url, :notice => "Invitation accepted successfully."
    else
      redirect_to root_url, :alert => "Invalid invitation."
    end
  end

  private
  def partner_params
    params.require(:partner).permit(:company_id, :subcontractor_id, :token, :status, :email)
  end
end