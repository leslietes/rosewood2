class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.belongs_to :room,     index: true
      t.belongs_to :occupant, index: true
      t.date       :start_date, null: false
      t.date       :end_date
    end
  end
end
