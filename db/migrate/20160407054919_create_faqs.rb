class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.integer :category_id
      t.string  :question
      t.text    :answer
      t.integer :position
      t.boolean :show
      t.integer :user_id, null: false
      t.timestamps null: false
    end
  end
end
