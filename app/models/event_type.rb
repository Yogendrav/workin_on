class EventType < ActiveRecord::Base
	has_many :events

	validates :name, presence: true, uniqueness: true
end