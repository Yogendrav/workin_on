class Partner < ActiveRecord::Base
  belongs_to :company
  belongs_to :subcontractor, class_name: "Admin", foreign_key: "subcontractor_id"
  belongs_to :project
  validates :email, presence: true
  validates :company_id, uniqueness: {scope: :email}
  validate :contact_exists?
  before_create :set_token_and_status_and_contractor

  private

  def set_token_and_status_and_contractor
    contractor = Admin.find_by_email(self.email)
    self.token, self.status, self.subcontractor_id  = SecureRandom.urlsafe_base64, "pending", contractor.id
  end

  def contact_exists?
    contractor = Admin.find_by_email(self.email)
    unless (contractor.present? && contractor.company.primary_contact.email == contractor.email)
      errors.add(:base, "No Company found with #{self.email} primary contact email") unless contractor
    end
  end
end