module AdminHelper

  def admin_user_row(user)
    content_tag :tr do
      content_tag(:td, link_to(user.name.humanize, generate_edit_path(user))) +
      content_tag(:td, user.is_a?(Admin) ? "Admin" : "Worker") +
      content_tag(:td, user.is_a?(Admin) ? "Admins" : user.team_name.try(:humanize)) +
      content_tag(:td, user.is_a?(Admin) ? "0" : user.skills.size) +
      content_tag(:td, user.is_a?(Admin) ? "0" : user.events.pluck(:project_id).uniq.size) +
      content_tag(:td, generate_delete_link(user))
    end
  end

  def generate_delete_link(user)
    if user.eql?(current_admin)
      ""
    else
      link_to("Delete", generate_delete_path(user), data: { confirm: "Are you sure?" }, method: :delete, class: "btn btn-xs btn-danger")
    end
  end

  def team_list_for_email_alert
    current_company.all_teams_except_admins_and_default
  end

  def selected_teams(user)
    (user.new_record? ? team_list_for_email_alert : user.teams_email_alerts).pluck(:id)
  end

  private

  def generate_edit_path(user)
    user.is_a?(Admin) ? edit_admin_path(user) : edit_worker_path(user)
  end

  def generate_delete_path(user)
    user.is_a?(Admin) ? admin_path(user) : worker_path(user)
  end
  
end