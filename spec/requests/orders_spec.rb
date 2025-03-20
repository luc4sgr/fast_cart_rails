require 'rails_helper'

RSpec.describe "Orders API", type: :request do
  let!(:user) { User.create!(name: "João", email: "joao@email.com", password: "password123") }
  let!(:product) { Product.create!(name: "Notebook", description: "Alta performance", price: 3000, stock: 10) }
  let(:token) { generate_jwt(user) } # 🔹 Gera um token válido para autenticação

  describe "POST /orders" do
    context "quando cria um pedido com sucesso" do
      it "retorna status 201 (Created)" do
        order_params = {
          order: {
            user_id: user.id,
            products: [ { product_id: product.id, quantity: 2 } ]
          }
        }

        # 🔹 Faz a requisição autenticada
        post "/orders", params: order_params, headers: { "Authorization" => "Bearer #{token}" }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["status"]).to eq("pendente")
      end
    end

    context "quando tenta criar um pedido sem estoque suficiente" do
      it "retorna status 422 (Unprocessable Entity)" do
        order_params = {
          order: {
            user_id: user.id,
            products: [ { product_id: product.id, quantity: 100 } ] # 🔹 Excede o estoque disponível
          }
        }

        post "/orders", params: order_params, headers: { "Authorization" => "Bearer #{token}" }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
