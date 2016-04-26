class BillingUtility < ActiveRecord::Base
  belongs_to :billing_detail
  
  def self.get_electricity(billing_id)
    includes(:billing_detail).where(billing_id: billing_id, utility_name: 'Electricity')
  end
  
  def self.get_water(billing_id)
    includes(:billing_detail).where(billing_id: billing_id, utility_name: 'Water')
  end
  
  def calculate_electricity
    elec = Utility.where(name: 'Electricity').first
    amt = (to - from) * elec.first_rate
    update(amount: amt)
  end
  
  def calculate_water
    water = Utility.where(name: 'Water').first
    limit = water.first_limit
    
    usage = to - from
    
    if usage > limit
      amt = water.first_rate + ((usage - limit) * water.excess_rate)
    else
      amt = water.first_rate
    end
    
    update(amount: amt)
  end
end
