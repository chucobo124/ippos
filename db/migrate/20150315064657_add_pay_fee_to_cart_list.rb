class AddPayFeeToCartList < ActiveRecord::Migration
  def change
    add_column :cart_lists, :payment, :string
    add_column :cart_lists, :payfee, :integer
  end
end
