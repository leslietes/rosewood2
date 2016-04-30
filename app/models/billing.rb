class Billing < ActiveRecord::Base
  
  has_many :billing_details
  
  
  validates :room_month,      presence: true
  validates :room_year,       presence: true
  validates :utilities_month, presence: true
  validates :utilities_year , presence: true
  
  validates_uniqueness_of :room_month, scope: :room_year
  validates_uniqueness_of :utilities_month, scope: :utilities_year
  
  
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
      checkin.checkin_occupants.each do |checkin_occupant|
        occupant = dtl.billing_occupants.create(occupant_id: checkin_occupant.occupant_id,
                                                    user_id: user_id)
      end
      
    end
  end
  
  def self.get_electricity_charges(billing_id)
#    includes(:billing_details,:billing_utilities).where("billing_ = 'Electricity'")
  end
  
  def room_period
    "#{room_month} #{room_year}"
  end
  
  def utilities_period
    "#{utilities_month} #{utilities_year}"
  end
  
end
