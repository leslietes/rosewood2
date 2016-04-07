class HomeController < ApplicationController
  
  def index  
    @setting = Setting.first || Setting.new
  end
  
  def about
  end

  def contact
    @setting = Setting.first || Setting.new
  end
end
