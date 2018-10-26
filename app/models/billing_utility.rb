class BillingUtility < ActiveRecord::Base
  belongs_to :billing_detail

  def self.get_electricity(billing_id)
    includes(:billing_detail).where(billing_id: billing_id, utility_name: ELECTRICITY)
  end

  def self.get_water(billing_id)
    includes(:billing_detail).where(billing_id: billing_id, utility_name: WATER_MIN)
  end

  def calculate_electricity
    elec = Utility.where(name: ELECTRICITY).first
    amt = (to - from) * elec.first_rate
    update(amount: amt)
  end

  def calculate_water
    water = Utility.where(name: WATER_MIN).first
    limit = water.first_limit

    usage = to - from

    if usage > limit
      amt = ((usage - limit) * water.excess_rate)

      # add elec_excess new record
      elec_excess = self.dup
      elec_excess.utility_name = WATER_EXCESS
      elec_excess.amount       = amt
      elec_excess.save!
    end
    #update(amount: amt)
  end

  def remove!
    destroy
  end

end
