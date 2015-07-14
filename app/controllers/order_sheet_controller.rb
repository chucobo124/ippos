class OrderSheetController < ApplicationController
  def index
  	 date = Time.now.strftime("%Y%m%d")
     @order_sheets = CartList.where("no LIKE (?)", "%#{date}%").all.paginate(page: params[:page], per_page: 30)
     @order_sheet_number = @order_sheets.select(:no).distinct
  end
  def show_order_sheet
    no = params[:no]
    @order_sheets = CartList.where(:no => no)
  end
  def search_order_sheet
  	@searchKeyWord = params[:serchKeyWrod]
    @order_sheets_all = CartList.where("no LIKE (?)", "%#{@searchKeyWord}%").all 
  	@order_sheets = CartList.where("no LIKE (?)", "%#{@searchKeyWord}%").all.paginate(page: params[:page], per_page: 30)
  	@order_sheet_number = @order_sheets.select(:no).distinct
  end
end
