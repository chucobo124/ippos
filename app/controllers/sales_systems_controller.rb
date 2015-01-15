class SalesSystemsController < ApplicationController
  before_action :product_initailize
  # include SalesSystemsHelper
  def index

  end
  def add_cart
     product = params[:product][:no]
     amount = params[:amount] 
     @count = 0
     @total = 0
     if Product.where(:no => product).count > 0
       value = $redis.hget( 'CART'  , @sn)
       value = value ? Marshal.load(value) : []
       value.fill(product , value.size, amount.to_i)
       $redis.hset('CART' , @sn , Marshal.dump(value))
       cart_list
       #binding.pry
       #puts Marshal.load(value)
       #tail -f log/development.log
      # $redis.hset('CART' , @sn , Marshal.dump(value))
      #  Openstruct
      #  if value.present? (value is nil is flase , blank is true)  
      #  # 1
       # else 
       # 2
       # end 
     else

     end
    render :index 
  end

  def cart_list
    @user_cart = $redis.hget('CART' , @sn)
    @user_cart = @user_cart ? Marshal.load(@user_cart) : []
    @product_list = Product.where("no IN (#{@user_cart.join(',')})") unless @user_cart.empty?
  end

  def del_cart
    product = params[:product_no]
     @count = 0
     if Product.where(:no => product).count > 0
       value = $redis.hget( 'CART'  , @sn)
       value = value ? Marshal.load(value) : []
       value.delete(product)
       $redis.hset('CART' , @sn , Marshal.dump(value))
       cart_list
       #binding.pry
       #puts Marshal.load(value)
       #tail -f log/development.log
      # $redis.hset('CART' , @sn , Marshal.dump(value))
      #  Openstruct
      #  if value.present? (value is nil is flase , blank is true)  
      #  # 1
       # else 
       # 2
       # end 
     end
    render :index 
  end

  def save_cart_as_cash
    @sn = params[:sn]
    value = $redis.hget('CART' , @sn)
    value = value ? Marshal.load(value) : []
    @product_list = Product.where("no IN (#{value.join(',')})") unless value.empty?
    @product_list.each do |product|
      product.no
      qty = value.count(product.no)
      @cart_list = CartList.new(:no => @sn , :product_no => product.no, :amount => qty , :price => product.price)
      @cart_list.save
    end  

    redirect_to sales_systems_index_path
  end

  private 
  def product_initailize
    @price_total = $cookes
    @product = Product.new
    if CartList.where("DATE(created_at) = DATE(?)" , Time.now).count == 0 
      @sn = Time.now.strftime("%Y%m%d")  + sprintf("%04d",CartList.where("DATE(created_at) = DATE(?)" , Time.now).count + 1)
    else
      @sn = (CartList.where("DATE(created_at) = DATE(?)" , Time.now).last.no.to_i+1).to_s
    end 
    @items = []
  end
  def person_params
    params.require(:product).permit(:no ,:name ,:quantity ,:price)
  end 
end