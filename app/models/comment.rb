class Comment < ActiveRecord::Base
  belongs_to :admin
  belongs_to :event
end
