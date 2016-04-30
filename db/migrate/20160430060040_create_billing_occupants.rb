class CreateBillingOccupants < ActiveRecord::Migration
  def change
    create_table :billing_occupants do |t|
      t.integer :billing_detail_id, null: false
      t.integer :occupant_id, null: false
      t.integer :user_id,     null: false

      t.timestamps null: false
    end
  end
end
