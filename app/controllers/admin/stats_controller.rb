module Admin
    class StatsController < ApplicationController
      before_action :authenticate_admin

      def index
        total_users = User.count
        total_orders = Order.count
        total_sales = Order.sum(:total_price)

        top_products = Product.joins(:order_items)
                              .select("products.id, products.name, SUM(order_items.quantity) AS total_sold")
                              .group("products.id, products.name")
                              .order("total_sold DESC")
                              .limit(5)

        stats = {
          total_users: total_users,
          total_orders: total_orders,
          total_sales: total_sales,
          top_products: top_products
        }

        render json: stats
      end

      private

      def authenticate_admin
        render json: { error: "Acesso negado" }, status: :forbidden unless @current_user&.admin?
      end
    end
end
