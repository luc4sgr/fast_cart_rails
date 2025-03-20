module Admin
    class OrdersController < ApplicationController
      before_action :authenticate_admin
      before_action :set_order, only: [:show, :update, :destroy]
  
      # GET /admin/orders
      def index
        orders = Order.all
        render json: orders
      end
  
      # GET /admin/orders/:id
      def show
        render json: @order
      end
  
      # PATCH/PUT /admin/orders/:id
      def update
        if @order.update(order_params)
          render json: @order
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      end
  
      # DELETE /admin/orders/:id
      def destroy
        @order.destroy
        head :no_content
      end
  
      private
  
      def authenticate_admin
        render json: { error: "Acesso negado" }, status: :forbidden unless @current_user&.admin?
      end
  
      def set_order
        @order = Order.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Pedido não encontrado" }, status: :not_found
      end
  
      def ord
  