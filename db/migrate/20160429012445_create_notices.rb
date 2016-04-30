class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer    :checkin_id,   null: false
      t.date       :moveout_date, null: false
      t.string     :reason
      t.date       :date_received
      t.text       :notes
      t.integer    :user_id,      null: false
      
      t.timestamps null: false
    end
  end
end
