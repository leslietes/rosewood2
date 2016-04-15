class CreateCheckinOccupants < ActiveRecord::Migration
  def change
    create_table :checkin_occupants do |t|
      t.belongs_to :checkin, index: true
      t.belongs_to :occupant,index: true
      t.date       :start_date
      t.date       :end_date
      
      t.timestamps null: false
    end
  end
end
