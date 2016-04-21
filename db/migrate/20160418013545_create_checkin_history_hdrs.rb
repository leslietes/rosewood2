class CreateCheckinHistoryHdrs < ActiveRecord::Migration
  def change
    create_table :checkin_history_hdrs do |t|
      t.belongs_to :room,       index:   true
      t.integer    :room_no,    null:    false
      t.date       :start_date, null:    false
      t.date       :end_date      
      t.timestamps null: false
    end
  end
end
