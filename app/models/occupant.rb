class Occupant < ActiveRecord::Base

  has_attached_file :photo, :styles => {:medium => "192x192#", :small => "95x95#"}

  validates_attachment_content_type :photo, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]

  validates :first_name, presence: true
  validates :last_name,  presence: true

  has_many :checkins, through: :checkin_occupants
  has_many :rooms,    through: :checkins

  def self.waiting_for_room
    select(:id, :last_name, :first_name).where(waiting: true).order(last_name: :asc, first_name: :asc)
  end

  def self.add_to_billing_detail
    select(:id, :last_name, :first_name).order(last_name: :asc, first_name: :asc)
  end

  # status updated after check in
  def self.checked_in!(occupant_id)
    find(occupant_id).update(waiting: false)
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def address
    # remove blank fields then join with comma
    [address1,address2,city,province].reject(&:blank?).join(", ")
  end

  def age
    return "" if birthdate.blank?
    "(#{Date.today.year - birthdate.to_date.year} years old)"
  end

  def inactive!
    update(active: false)
  end
end
