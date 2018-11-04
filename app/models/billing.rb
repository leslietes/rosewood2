class Billing < ActiveRecord::Base

  has_many :billing_details

  validates :statement_date,          presence: true
  validates :advance_rent_period,     presence: true
  validates :utilities_reading_period,presence: true

  #validates_uniqueness_of :statement_date
  #validates_uniqueness_of :room_month, scope: [:room_year, :statement_date]
  #validates_uniqueness_of :utilities_month, scope: [:utilities_year, :statement_date]


  MONTHS = ["January","February","March","April","May","June","July","August","September","October","November","December"]
  YEAR   = [Date.today.year-1, Date.today.year,Date.today.year+1]

  def self.get_details(billing_id)
    where(id = billing_id).includes(:billing_details).order(room_no: :desc)
    #select billings.id, billing_dtls.room_no, (select billing_utilities.id from billing_utilities, billing_dtls where billing_utilities.id = 1 and billing_utilities.billing_dtl_id = billing_dtls.id) as elec from billings, billing_dtls where billings.id = 14 and billings.id = billing_dtls.billing_id;
  end

  def generate_billing_details(user_id)
    checkins = Checkin.all.includes(:checkin_details,:utilities).order(room_no: :asc)
    checkins.each do |checkin|

      # create billing detail
      dtl = billing_details.create(checkin_id: checkin.id,
                                      room_no: checkin.room_no,
                                      user_id: user_id)

      checkin.checkin_details.each do |checkin_detail|
        # automatically set amount except for water and elec
        if (checkin_detail.utility.name == ELECTRICITY)
          utility_period = electricity_reading_period
          amount = 0

        elsif checkin_detail.utility.name == ROOM_RATE
          utility_period = advance_rent_period
          amount = checkin_detail.amount

        elsif checkin_detail.utility.name == WATER_MIN
          utility_period = electricity_reading_period
          amount = checkin_detail.amount

        elsif checkin_detail.utility.name == WATER_EXCESS
          next
        #  utility_period = ''
        #  amount = 0

        else
          utility_period = utilities_reading_period
          amount = checkin_detail.amount
        end

        utl = dtl.billing_utilities.create(utility_name: checkin_detail.utility.name,
                                         utility_period: utility_period,
                                                   rate: checkin_detail.amount,
                                                 amount: amount,
                                             billing_id: id,
                                             sort_order: checkin_detail.utility.sort_order,
                                                user_id: user_id)
      end

      # create billing occupants
      checkin.checkin_occupants.each do |checkin_occupant|
        occupant = dtl.billing_occupants.create(occupant_id: checkin_occupant.occupant_id,
                                                    user_id: user_id)
      end

    end
  end

  def generate_final_billing(checkin_id,user_id)
    checkin = Checkin.where(id: checkin_id).includes(:checkin_details,:utilities)

    # create billing detail
    dtl = billing_details.create(checkin_id: checkin.first.id,
                                    room_no: checkin.first.room_no,
                                    user_id: user_id)

    checkin.first.checkin_details.each do |checkin_detail|
    # automatically set amount except for water and elec
      if (checkin_detail.utility.name != 'Water') && (checkin_detail.utility.name != 'Electricity')
        amount = checkin_detail.amount
      else
        amount = 0
      end

      utl = dtl.billing_utilities.create(utility_name: checkin_detail.utility.name,
                                                 rate: checkin_detail.amount,
                                               amount: amount,
                                           billing_id: id,
                                              user_id: user_id)
    end

    # create billing occupants
    checkin.first.checkin_occupants.each do |checkin_occupant|
      occupant = dtl.billing_occupants.create(occupant_id: checkin_occupant.occupant_id,
                                                  user_id: user_id)
    end
  end

  def self.get_electricity_charges(billing_id)
#    includes(:billing_details,:billing_utilities).where("billing_ = 'Electricity'")
  end



  #def room_period
  #  "#{room_month} #{room_year}"
  #end

  #def utilities_period
  #  "#{utilities_month} #{utilities_year}"
  #end

end
