class ProductsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :set_product, only: [:show]

  def index
    products = Product.all
    render json: products
  end

  def show
    render json: @product
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Produto não encontrado" }, status: :not_found
  end
end
