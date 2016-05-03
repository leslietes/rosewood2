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
    
    add_index :checkin_occupants, :checkin_id
    add_index :checkin_occupants, :occupant_id
  end
end
