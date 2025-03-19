class OrdersController < ApplicationController
    before_action :set_order, only: [:show, :update, :destroy]
  
    # GET /orders
    def index
      @orders = Order.all
      render json: @orders
    end
  
    # GET /orders/:id
    def show
      render json: @order
    end
  
    def create
        ActiveRecord::Base.transaction do
          @order = Order.new(user_id: params[:order][:user_id], status: "pendente", total_price: 0)
      
          if @order.save
            total_price = 0
      
            params[:order][:products].each do |product_item|
              product = Product.find(product_item[:product_id])
      
              if product.stock >= product_item[:quantity]
                order_item_price = product.price * product_item[:quantity]
                total_price += order_item_price
      
                OrderItem.create!(
                  order: @order,
                  product: product,
                  quantity: product_item[:quantity],
                  price: order_item_price
                )
      
                product.update!(stock: product.stock - product_item[:quantity])
              else
                raise ActiveRecord::Rollback, "Estoque insuficiente para o produto #{product.name}"
              end
            end
      
            @order.update!(total_price: total_price)
      
            render json: @order, include: :order_items, status: :created
          else
            render json: @order.errors, status: :unprocessable_entity
          end
        end
      end
      
  
    # PATCH/PUT /orders/:id
    def update
      if @order.update(order_params)
        render json: @order
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /orders/:id
    def destroy
      @order.destroy
      head :no_content
    end
  
    private
  
    def set_order
      @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Pedido não encontrado" }, status: :not_found
    end
  
    def order_params
      params.require(:order).permit(:user_id, :total_price, :status)
    end
  end
  