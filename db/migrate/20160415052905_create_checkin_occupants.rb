class CreateCheckinOccupants < ActiveRecord::Migration
  def change
    create_table :checkin_occupants do |t|
      t.belongs_to :checkin, index: true
      t.belongs_to :occupant,index: true
      t.string     :start_date
      t.string     :end_date
      t.integer    :user_id, null: false
      t.timestamps null: false
    end
  end
end
