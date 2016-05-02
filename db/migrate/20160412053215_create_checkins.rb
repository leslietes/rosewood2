class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.belongs_to :room,       index:   true
      t.integer    :room_no,    null:    false
      t.boolean    :checkout,   default: false
      
      t.string     :start_date, null:    false
      t.string     :end_date
      
      t.integer    :user_id,    null:    false
      t.timestamps null: false
    end
  end
end
