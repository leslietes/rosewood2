class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :get_settings
  
  protected
  
  def get_settings
    @setting = Setting.first || Setting.new
  end
  
  def after_sign_in_path_for(resource)
    admin_setting_url
  end
end
