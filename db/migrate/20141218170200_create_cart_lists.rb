class CreateCartLists < ActiveRecord::Migration
  def change
    create_table :cart_lists do |t|
      t.string :no
      t.string :product_no
      t.integer :amount
      t.integer :price

      t.timestamps
    end
  end
end
