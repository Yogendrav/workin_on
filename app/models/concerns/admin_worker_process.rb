module AdminWorkerProcess
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

    belongs_to :company
    belongs_to :team
    has_many :messages

    has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" },
      url: '/system/:class/:id/:style/:normalized_photo_name',
      path: ":rails_root/public/system/:class/:id/:style/:normalized_photo_name",
      default_url: "missing.jpeg"

    validates_attachment_content_type :photo, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, message: 'type is not allowed (only jpeg/png/gif images allowed)'
    validates :name, :phone, :company_id, presence: true
    validates :phone, uniqueness: true , format: { with: /\d{3}-\d{3}-\d{4}/, message: "number is not in valid format." }

    before_validation :phone_masking_remove

    scope :list, ->{ where(active: true).order(name: :asc) }

    Paperclip.interpolates :normalized_photo_name do |attachment, style|
      attachment.instance.normalized_photo_file_name
    end
  end

  def normalized_photo_file_name
    transliterate(self.photo_file_name)
  end

  module ClassMethods
    # put here class methods
  end

  private
  
  # Style image name
  def transliterate(str)
    str.downcase!
    str.gsub!(/'/, '')
    str.gsub!(/[^A-Za-z0-9_\.]+/, ' ')
    str.strip!
    str.gsub!(/\ +/, '-')
    str
  end

  def phone_masking_remove
    self.phone = phone.gsub(/([()])/, "").gsub(" ","-")
  end
  
end