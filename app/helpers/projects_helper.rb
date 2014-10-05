module ProjectsHelper
  def project_row(project)
    content_tag :tr do
      content_tag(:td, project.name.humanize) +
      content_tag(:td, "0") +
      content_tag(:td, "0")
    end
  end
  def select_company_partner
    partner = current_company.partners.where(:status => true)
    partner.all.map{|a| [a.subcontractor.company.name, a.subcontractor.company.id]}
  end
end