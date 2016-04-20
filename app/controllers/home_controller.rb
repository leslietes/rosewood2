class HomeController < ApplicationController
  
  def index  
    @setting = Setting.first || Setting.new
  end

  def contact
    @setting = Setting.first || Setting.new
    
    return unless request.post?
    
    Notifier.contact_us(params).deliver_now
  end
end
