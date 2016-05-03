class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :room_no
      t.integer :max_occupants
      t.decimal :daily_rate,precision: 6, scale: 2
      t.decimal :room_rate, precision: 8, scale: 2
      t.boolean :active,    default: true
      t.boolean :occupied,  default: false
      t.integer :user_id,   null:    false
      
      t.timestamps null: false
    end
    
    add_index :rooms, :room_no, unique: true
  end
end
