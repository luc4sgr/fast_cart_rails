class Admin::DashboardController < ApplicationController
end
module Admin
    class DashboardController < ApplicationController
      before_action :authenticate_admin

      def index
        render json: { message: "Bem-vindo ao Painel de Administração!", users: User.all, products: Product.all, orders: Order.all }
      end

      private

      def authenticate_admin
        render json: { error: "Acesso negado" }, status: :forbidden unless @current_user&.admin?
      end
    end
end
