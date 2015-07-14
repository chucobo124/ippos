class Product < ActiveRecord::Base
  validates :no, :presence => { :message => "請輸入產品編號"}
  validates :name , :presence => { :message => "請輸入產品名稱"}
  validates :quantity, :presence => { :message => "請輸入產品數量"}
  validates :price, :presence => { :message => "請輸入產品價格"}
end
