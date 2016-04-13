class CreateUtilities < ActiveRecord::Migration
  def change
    create_table :utilities do |t|
      t.string  :name
      t.text    :description
      t.decimal :rate, precision: 6, scale: 2
      t.string  :unit

      t.timestamps null: false
    end
  end
end
