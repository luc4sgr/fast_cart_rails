class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # Método para verificar se o usuário é admin
  def admin?
    self.admin
  end
end
