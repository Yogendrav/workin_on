class Message < ActiveRecord::Base
  belongs_to :admin
  belongs_to :worker

  validates :worker_id, :admin_id, :notes, presence: true

end