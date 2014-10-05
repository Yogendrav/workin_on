module TeamsHelper

  def members_count(team)
    team_members_count = case team.name.downcase
      when "admins" then team.admins.size
      when "default" then team.members_size
      else team.workers.size
    end
    team_members_count
  end

  def projects_count(team)
    team.workers.map{|worker| worker.events.pluck(:project_id).uniq}.flatten.uniq.size
  end

  def disable_team_button(team)
    unless ["admins", "default"].include?(team.name.downcase)
      link_to "Delete", team_path(team), data: { confirm: "Are you sure?" }, method: :delete, class: "btn btn-xs btn-danger"
    end
  end

  def assign_users
    current_company.worker_with_team_name_list
  end

  def selected_workers(team)
    team.workers.pluck(:id)
  end

end