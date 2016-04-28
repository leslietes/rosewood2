module ApplicationHelper
  
  def to_currency(amount)
    number_to_currency(amount, unit: '')
  end
  
  def to_status(status)
    if status == false
      return 'No'
    else
      return 'Yes'
    end
  end
end
