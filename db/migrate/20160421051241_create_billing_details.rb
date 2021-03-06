class CreateBillingDetails < ActiveRecord::Migration
  def change
    create_table :billing_details do |t|
      t.integer   :billing_id,   null: false
      t.integer   :checkin_id,   null: false
      t.integer   :room_no,      null: false
      t.integer   :user_id,      null: false
      t.timestamps null: false
    end
    
    add_index :billing_details, :billing_id
    add_index :billing_details, :checkin_id
  end
end
