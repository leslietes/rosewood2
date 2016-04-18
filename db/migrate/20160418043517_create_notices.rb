class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :room_no, null: false
      t.text    :occupants
      t.text    :reason
      t.date    :move_out_date
      t.date    :date_received
      t.integer :user_id
      
      t.text    :proposed_occupants
      t.boolean :paid, default: false
      t.date    :checkin_date
      t.timestamps null: false
    end
  end
end
