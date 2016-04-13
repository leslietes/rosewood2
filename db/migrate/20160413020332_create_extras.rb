class CreateExtras < ActiveRecord::Migration
  def change
    create_table :extras do |t|

      t.timestamps null: false
    end
  end
end
