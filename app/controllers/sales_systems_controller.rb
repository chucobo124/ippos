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
     @payfee = 0
     if Product.where(:no => product).count >= 0
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
    @product_list = Product.where(:no => @user_cart) unless @user_cart.empty?
    #@product_list = Product.where("no IN (#{@user_cart.join(',')})") unless @user_cart.empty?
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
    print = PrintFile.new
    sleep(0.2)
    @printtest = ""
    @sn = params[:sn]
    @payfee = params[:payfee]
    @total = 0
    @charge = 0
    value = $redis.hget('CART' , @sn)
    value = value ? Marshal.load(value) : []
    sleep(0.4)
    print.printFileLeftRaw("\ez\x01\n"+"編號:".encode("Big5")+@sn.to_s)
    @product_list = Product.where(:no => value) unless value.empty?
    if @product_list.nil?
      redirect_to sales_systems_index_path
    else
      @product_list.each do |product|
        qty = value.count(product.no)
        @cart_list = CartList.new(:no => @sn , :product_no => product.no, :amount => qty , :price => product.price)
        @cart_list.save
        sleep(0.4)
      print.printFileLeftRaw("\ez\x01\n"+((product.name).first(15)).encode("Big5").ljust(10,"\v")+(("$".encode("Big5") + (product.price).to_s).first(5)).rjust(5,"\v"))
        @printtest += "\ez\x01\n"+((product.name).first(15)).encode("Big5").ljust(10,"\v")+(("$".encode("Big5") + (product.price).to_s).first(5)).rjust(5,"\v") 
        @total += product.price
        @created_at = CartList.where(:no => @sn)[0].created_at
      end
        if @payfee == 0
          @payfee = @total
        end
        @charge = @payfee.to_i - @total
        if @charge < 0 
          @charge = 0 
          @payfee = @total
        end
        @cart_list= CartList.where(:no => @sn)
        @cart_list.update_all(:payment => "cash" , :payfee => @payfee)
       print.printFileLeftRaw("\ez\x01\n"+"小計".encode("Big5").ljust(10,"\v")+ "\v\v\v\v\v" +"$".encode("Big5") + @total.to_s)
       print.printFileLeftRaw("\ez\x01\n"+"現金".encode("Big5").ljust(10,"\v")+ "\v\v\v\v\v" +"$".encode("Big5") + @total.to_s)
       print.printFileLeftRaw("\ez\x01\n"+"收錢".encode("Big5")+ "\v\v" +"$".encode("Big5") + @payfee.to_s )
       print.printFileLeftRaw("\ez\x01\n"+"找".encode("Big5")+ @charge.to_s)
       print.printFileLeftRaw("\ez\x01\n"+@created_at.to_s)
       print.printFileLeftRaw("\f")
       print.printFileCut
       #@printtest += "\ez\x01\n"+"小計".encode("Big5").ljust(10,"\v")+ "\v\v\v\v\v" +"$".encode("Big5") + @total.to_s
       #@printtest += "\ez\x01\n"+"現金".encode("Big5").ljust(10,"\v")+ "\v\v\v\v\v" +"$".encode("Big5") + @total.to_s
       #@printtest += "\ez\x01\n"+"收錢".encode("Big5")+ "\v\v" +"$".encode("Big5") + @payfee.to_s
       #@printtest += "\ez\x01\n"+"找".encode("Big5")+ @charge.to_s
       #@printtest += "\ez\x01\n"+"編號:".encode("Big5")+@sn.to_s
       #@printtest += "\ez\x01\f"
      redirect_to sales_systems_index_path
    end
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