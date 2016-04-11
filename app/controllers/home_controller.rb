class HomeController < ApplicationController
  
  def index  
    
  end

  def contact
    return unless request.post?
    
    Notifier.contact_us(params).deliver_now
  end
end
