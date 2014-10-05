module PartnersHelper
  def primary_contact_email
    Company.all_except(current_company).map do |company|
      [company.primary_contact.email, company.primary_contact.id]
    end
  end
end
