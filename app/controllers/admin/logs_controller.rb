module Admin
    class LogsController < ApplicationController
      before_action :authenticate_admin

      # GET /admin/logs
      def index
        logs = AdminLog.order(created_at: :desc).limit(50) # Pegando os últimos 50 logs
        render json: logs
      end

      private

      def authenticate_admin
        render json: { error: "Acesso negado" }, status: :forbidden unless @current_user&.admin?
      end
    end
end
