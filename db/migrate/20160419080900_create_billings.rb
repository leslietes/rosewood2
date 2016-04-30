class CreateBillings < ActiveRecord::Migration
  def change
    create_table :billings do |t|
      t.date       :statement_date
      t.string     :room_month
      t.string     :room_year
      t.string     :utilities_month
      t.string     :utilities_year
      t.integer    :user_id, null: false
      t.timestamps null: false
    end
  end
end
