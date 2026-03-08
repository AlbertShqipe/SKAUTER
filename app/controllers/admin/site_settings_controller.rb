class Admin::SiteSettingsController < ApplicationController
  layout "admin"
  before_action :require_admin

  def index
    @settings = SiteSetting.all
  end

  def update
    setting = SiteSetting.find_by(key: params[:key])
    setting.update(value: params[:value] == "true")
    redirect_to admin_site_settings_path, notice: "Setting updated"
  end

  private

  def require_admin
    redirect_to root_path unless current_user.admin?
  end
end
