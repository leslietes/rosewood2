class CreateBillingOccupants < ActiveRecord::Migration
  def change
    create_table :billing_occupants do |t|
      t.integer :billing_detail_id, null: false
      t.integer :occupant_id, null: false
      t.integer :user_id,     null: false

      t.timestamps null: false
    end
    
    add_index :billing_occupants, :billing_detail_id
    add_index :billing_occupants, :occupant_id
  end
end
