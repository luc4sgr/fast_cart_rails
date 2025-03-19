Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*' # ⚠️ Altere '*' para o domínio do frontend em produção
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end
  