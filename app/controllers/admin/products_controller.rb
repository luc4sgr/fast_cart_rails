module Admin
    class ProductsController < ApplicationController
      before_action :authenticate_admin
      before_action :set_product, only: [ :show, :update, :destroy ]

      # GET /admin/products
      def index
        products = Product.all
        render json: products
      end

      # GET /admin/products/:id
      def show
        render json: @product
      end

      # POST /admin/products
      def create
        product = Product.new(product_params)
        if product.save
          AdminLoggerService.log(@current_user, "Criou produto", "Produto #{product.name} criado com preço #{product.price}")
          render json: product, status: :created
        else
          render json: product.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /admin/products/:id
      def update
        if @product.update(product_params)
          AdminLoggerService.log(@current_user, "Atualizou produto", "Produto #{@product.name} atualizado")
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      # DELETE /admin/products/:id
      def destroy
        AdminLoggerService.log(@current_user, "Deletou produto", "Produto #{@product.name} foi excluído")
        @product.destroy
        head :no_content
      end

      private

      def authenticate_admin
        render json: { error: "Acesso negado" }, status: :forbidden unless @current_user&.admin?
      end

      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Produto não encontrado" }, status: :not_found
      end

      def product_params
        params.require(:product).permit(:name, :description, :price, :stock)
      end
    end
end
