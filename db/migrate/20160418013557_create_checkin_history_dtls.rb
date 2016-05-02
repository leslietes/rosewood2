class CreateCheckinHistoryDtls < ActiveRecord::Migration
  def change
    create_table :checkin_history_dtls do |t|
      t.belongs_to :checkin_history_hdr, index: true
      t.belongs_to :occupant,index: true
      t.string     :start_date
      t.string     :end_date
      
      t.timestamps null: false
    end
  end
end
