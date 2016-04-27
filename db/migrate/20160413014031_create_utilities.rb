class CreateUtilities < ActiveRecord::Migration
  def change
    create_table :utilities do |t|
      t.string  :name
      t.text    :description
      t.decimal :first_limit, precision: 6, scale: 2
      t.decimal :first_rate,  precision: 6, scale: 2
      t.decimal :excess_rate, precision: 6, scale: 2
      t.string  :unit
      t.string  :category
      t.integer :user_id, null: false
      t.timestamps null: false
    end
  end
end
