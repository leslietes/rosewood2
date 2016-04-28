class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :active,:boolean, default: true
    add_column :users, :name,  :string
  end
end
