class CreateCheckinDetails < ActiveRecord::Migration
  def change
    create_table :checkin_details do |t|
      t.belongs_to :checkin, index: true
      t.belongs_to :utility, index: true
      t.decimal    :amount
      t.date       :start_date
      t.date       :end_date
      
      t.integer    :user_id
      
      t.timestamps null: false
    end
  end
end
