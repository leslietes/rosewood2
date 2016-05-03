class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer  :room_id,     null: false
      t.string   :name,        null: false
      t.string   :movein_date, null: false
      t.integer  :user_id,     null: false
      t.timestamps null: false
    end
    
    add_index :reservations, :room_id
  end
end
