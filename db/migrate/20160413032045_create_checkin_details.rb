class CreateCheckinDetails < ActiveRecord::Migration
  def change
    create_table :checkin_details do |t|
      t.belongs_to :checkin, index: true
      t.belongs_to :utility, index: true
      t.decimal    :amount
      t.string     :start_date
      t.string     :end_date
      
      t.integer    :user_id, null: false
      
      t.timestamps null: false
    end
    
    add_index :checkin_details, :checkin_id
    add_index :checkin_details, :utilitiy_id
  end
end
