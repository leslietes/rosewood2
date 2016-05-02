class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer    :checkin_id,   null: false
      t.string     :moveout_date, null: false
      t.string     :reason
      t.string     :date_received
      t.text       :notes
      t.integer    :user_id,      null: false
      
      t.timestamps null: false
    end
  end
end
