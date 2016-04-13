class HomeController < ApplicationController
  
  def index  
    @setting = Setting.first || Setting.new
  end

  def contact
    return unless request.post?
    
    Notifier.contact_us(params).deliver_now
  end
end
