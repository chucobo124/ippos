class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :no
      t.string :name
      t.integer :quantity
      t.integer :price
      t.integer :agent_price
      t.timestamps
    end
  end
end
