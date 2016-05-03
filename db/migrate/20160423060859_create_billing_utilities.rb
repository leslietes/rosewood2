class CreateBillingUtilities < ActiveRecord::Migration
  def change
    create_table :billing_utilities do |t|
        t.integer   :billing_id,        null: false
        t.integer   :billing_detail_id, null: false
        t.string    :utility_name,      null: false
        
        # for room stay if starting mid month
        t.string    :start_date
        t.string    :end_date
        
        # for water and electricity
        t.decimal   :rate,              precision: 8, scale: 2, default: 0
        t.decimal   :from,              precision: 6, scale: 2, default: 0
        
        t.decimal   :to,                precision: 6, scale: 2, default: 0
        t.decimal   :amount,            precision: 8, scale: 2, default: 0
        t.integer   :user_id,           null: false
        t.timestamps null: false
    end
    
    add_index :billing_utilities, :billing_id
    add_index :billing_utilities, :billing_detail_id
  end
end
