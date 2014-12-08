class ProductsController < ApplicationController
  def index
      @products = Product.all
  end
  def new
      @product = Product.new
  end
  def create
      @product = Product.new(person_params)    
      respond_to do |format|
        if @product.save
          format.html { redirect_to :products_new, notice: 'Test was successfully created.' }
        else
          format.html { render :new }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end 
      end
  end
  private 
    def person_params
      params.require(:product).permit(:no ,:name ,:quantity ,:price)
    end 
end
