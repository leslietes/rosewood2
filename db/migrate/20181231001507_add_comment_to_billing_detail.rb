class AddCommentToBillingDetail < ActiveRecord::Migration
  def change
    add_column :billing_details, :comments, :text
  end
end
