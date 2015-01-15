class OrderSheetController < ApplicationController
  def index
     @order_sheets = CartList.all
     @order_sheet_number = CartList.select(:no).distinct
  end
  def show_order_sheet
    no = params[:no]
    @order_sheets = CartList.where(:no => no)
  end
end
