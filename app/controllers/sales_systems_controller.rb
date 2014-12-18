class SalesSystemsController < ApplicationController
  include SalesSystemsHelper
  def index
    @product = Product.new
    @params = params
    @sheet_no = "1"
    unless (params[:product] && params[:product][:no]) == nil
      @cart_list =  add_cart(params, @sheet_no)
    end
    cart_list(@sheet_no)
    puts cart_list(@sheet_no)
    #@product_list = Porduct.where(:no => @cart_list)
  end
  private 
  def person_params
    params.require(:product).permit(:no ,:name ,:quantity ,:price)
  end 
end
