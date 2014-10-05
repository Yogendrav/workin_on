class Project < ActiveRecord::Base
  belongs_to :company
  has_many :partners
  has_many :events
  has_many :project_shares
  has_many :tasks
  scope :list, ->{where(active: true).order(name: :asc)}

  after_create :get_lat_long
  validate :project_exist?, on: :create
  # validates :active_radius, numericality: true, allow_nil: true
  validates_numericality_of :active_radius, on: :create


  private
  def get_lat_long
    lat_long = Geocoder.coordinates("#{self.address}")
    address_latt = lat_long.first
    address_long = lat_long.last
    self.update(address_latt: address_latt, address_long: address_long, active: true)
  end

  def project_exist?
    self.errors.add(:base, "#{self.name.humanize} already exist.") if self.company.projects.where(name: self.name).present?
  end
end