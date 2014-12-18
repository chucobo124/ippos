module SalesSystemsHelper
 def add_cart(params , sheet_no )
    id = params[:product][:no]
    if Product.where(:no => id).count > 0
      value = $redis.hget('CART' , sheet_no)
      value = value ? Marshal.load(value) : []
      value << id
      $redis.hset('CART' , sheet_no , Marshal.dump(value))
      return value
    end
  end

  def cart_list(sheet_no)
    value = $redis.hget('CART' , sheet_no)
    @user_cart = $redis.hget('CART' , sheet_no)
    @user_cart = @user_cart ? Marshal.load(value) : []
    @product = Product.where("no IN (#{@user_cart.join(',')})") unless @user_cart.empty?
  end
end
