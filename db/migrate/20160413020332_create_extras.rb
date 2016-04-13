class CreateExtras < ActiveRecord::Migration
  def change
    create_table :extras do |t|
      t.string  :name
      t.string  :description
      t.decimal :rate
      t.string  :unit
      
      t.timestamps null: false
    end
  end
end
