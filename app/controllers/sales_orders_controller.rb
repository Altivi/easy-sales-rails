class SalesOrdersController < ApplicationController
    before_action :set_sales_order, only: [:show, :edit_form, :update]
    # before_action :set_delete_all_sales_order, only: [:delete_all]

    def create_sales_order
      if params[:user_id].present?
        @user = User.find_by(id: params[:user_id])
        @sales_order = SalesOrder.create(sales_order_params)
        @sales_order.sales_user_id = @user.id
        @sales_order.save
        render :json=> {:status => true,:message => "Sales Order created!"}, :status=>200
      else
        render :json=> {:status => false,:message => "Something Went Wrong!"}, :status=>201
      end
    end

    def index
      if params[:search_text].present?
        sales_orders = SalesOrder.search_box(params[:search_text],current_user.id).get_json_sales_orders
      else
        sales_orders = SalesOrder.search(params,current_user.id,false).get_json_sales_orders
      end
      render status: 200, json: sales_orders.as_json
    end

    def show
      render status: 200, json: @sales_order.get_json_sales_order_show.as_json  
    end

    def edit_form
      render status: 200, json: @sales_order.get_json_sales_order_edit.as_json  
    end

    def update
      if @sales_order.update_attributes(sales_order_params)
        render status: 200, json: { sales_order_id: @sales_order.id}
      else
        render status: 200, json: { message: @sales_order.errors.full_messages.first }
      end
    end

    # def delete_all
    #   @sales_order_ids.each do |id|
    #     sales_order = SalesOrder.find(id.to_i)
    #     sales_order.update_attribute(:is_active, false)
    #   end
    #   render json: {status: :ok}
    # end

  def sales_order_delete
    if params[:user_id].present?
      @user = User.find_by(id: params[:user_id])
      @split_id = params[:sales_order_id]
      @sales_order_id = @split_id.split(',')
      if @sales_order_id.present?
        begin
          @sales_order_id.each do |id|
            @sales_order = SalesOrder.find(id)
            if @sales_order.present?
              @sales_order.delete
            end
          end
          render :json=> {:status => true,:message => "Sales Order deleted!"}, :status=>200
        rescue Exception => e
          render :json=> {:status => true,:message => "No data!"}, :status=>200
        end
      else
        render :json=> {:status => true,:message => "No data!"}, :status=>200
      end
    else
      render :json=> {:status => false,:message => "Something Went Wrong!"}, :status=>201
    end
  end

    def refresh
      current_user.refresh_orders
      render json: {status: :ok}
    end

    def get_sales_orders
      if params[:user_id].present?
        @user = User.find_by(id: params[:user_id])
        @sales_order = SalesOrder.where(sales_user_id: @user.id)
        if @sales_order.present?
          render :json=> {:status => true,:message => "Sales Order list!"}, :status=>200
        else
          render :json=> {:status => true,:message => "No data!"}, :status=>200
        end
      else
        render :json=> {:status => true,:message => "Something Went Wrong!"}, :status=>201
      end
      # salesOrders = SalesOrder.sales_sales_orders(current_user)
      # render status: 200, json: SalesOrder.get_json_sales_orders_dropdown(salesOrders)
    end

    private
      def set_sales_order
          @sales_order = SalesOrder.find(params[:id])
      end

      def set_delete_all_sales_order
          @sales_order_ids = JSON.parse(params[:ids])
      end

      def sales_order_params
        params.require(:sales_order).permit(:id, :customer_user_id, :contact_user_id)
      end
end
