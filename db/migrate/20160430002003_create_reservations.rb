class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer  :room_id,     null: false
      t.string   :name,        null: false
      t.date     :movein_date, null: false
      t.integer  :user_id,     null: false
      t.timestamps null: false
    end
  end
end
