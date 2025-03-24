module Admin
  class UsersController < ApplicationController
    before_action :authenticate_admin
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /admin/users
    def index
      users = User.all
      render json: users
    end

    # GET /admin/users/:id
    def show
      render json: @user
    end

    # POST /admin/users
    def create
      user = User.new(user_params)
      if user.save
        render json: user, status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/users/:id
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /admin/users/:id
    def destroy
      @user.destroy
      head :no_content
    end

    private

    def authenticate_admin
      render json: { error: "Acesso negado" }, status: :forbidden unless @current_user&.admin?
    end

    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Usuário não encontrado" }, status: :not_found
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :admin)
    end
  end
end
