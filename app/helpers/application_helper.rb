module ApplicationHelper
  
  def to_currency(amount)
    number_to_currency(amount, unit: 'P')
  end
  
  def to_status(status)
    if status == false
      return 'No'
    else
      return 'Yes'
    end
  end
end
