require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# 🔹 Carregar automaticamente todos os arquivos dentro de spec/support
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }

RSpec.configure do |config|
  # 🔹 Inclui helpers de autenticação nos testes de requisição
  config.include AuthHelper, type: :request

  # 🔹 Caminho para fixtures
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]

  # 🔹 Mantém os testes dentro de uma transação (para evitar poluição do banco)
  config.use_transactional_fixtures = true

  # 🔹 Remove ruídos dos logs
  config.filter_rails_from_backtrace!
end
