class UsersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :authorize_admin, only: :index
  
  def index
    @users = User.all
  end
    
  private
    
  def authorize_admin
    return if !current_user.admin?
  end
end
