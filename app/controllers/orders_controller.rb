class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :authorize_owner, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.where(user_id: @current_user.id).includes(:order_items, :products)
    render json: @orders, include: [:order_items, :products]
  end

  # GET /orders/:id
  def show
    render json: @order, include: [:order_items, :products]
  end

  # POST /orders
  def create
    ActiveRecord::Base.transaction do
      @order = Order.new(user: @current_user, status: "pendente", total_price: 0)

      if @order.save
        total_price = 0

        params[:order][:products].each do |item|
          product = Product.find(item[:product_id])
          quantity = item[:quantity].to_i

          if product.stock >= quantity
            price = product.price * quantity
            total_price += price

            OrderItem.create!(
              order: @order,
              product: product,
              quantity: quantity,
              price: price
            )

            product.update!(stock: product.stock - quantity)
          else
            render json: { error: "Estoque insuficiente para #{product.name}" }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end
        end

        @order.update!(total_price: total_price)

        # Envia notificações
        NotificationService.send_notification(@current_user, "Seu pedido ##{@order.id} foi criado com sucesso!")
        User.where(admin: true).each do |admin|
          NotificationService.send_notification(admin, "Novo pedido ##{@order.id} criado por #{@current_user.name}")
        end

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
    @order = Order.find_by(id: params[:id])
    render json: { error: "Pedido não encontrado" }, status: :not_found unless @order
  end

  def authorize_owner
    render json: { error: "Acesso negado" }, status: :forbidden unless @order.user_id == @current_user.id
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
