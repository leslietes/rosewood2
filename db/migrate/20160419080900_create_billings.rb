class CreateBillings < ActiveRecord::Migration
  def change
    create_table :billings do |t|
      t.string     :statement_date
      t.string     :advance_rent_period
      t.string     :electricity_reading_period
      t.string     :utilities_reading_period
      t.boolean    :final_billing, default: false
      t.integer    :user_id, null: false
      t.timestamps null: false
    end
  end
end
