module ApplicationHelper
  def admin_namespace?
    controller_path.start_with?("admin/")
  end
end
