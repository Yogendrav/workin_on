class ProjectShare < ActiveRecord::Base
	belongs_to :company
	belongs_to :project
	belongs_to :subcontractor, class_name: "Admin"
end