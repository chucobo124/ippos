class SalesSystemsController < ApplicationController
  def index
    @product = Product.new
  end
  def search_product
    @product =Product.new(person_params)
    @search = Product.where(no: @product.no).take
  end

  private 
  def person_params
    params.require(:product).permit(:no ,:name ,:quantity ,:price)
  end 
end
