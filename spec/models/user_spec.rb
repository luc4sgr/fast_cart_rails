require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(name: "João", email: "joao@email.com", password: "password123", admin: false)
  }

  it "é válido com nome, email e senha" do
    expect(subject).to be_valid
  end

  it "é inválido sem um nome" do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it "é inválido sem um email" do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  it "é inválido sem uma senha" do
    subject.password = nil
    expect(subject).not_to be_valid
  end

  it "não permite emails duplicados" do
    subject.save!  # Salva o usuário original no banco antes de criar o duplicado

    user_duplicate = User.new(name: "Lucas", email: subject.email, password: "password123")
    expect(user_duplicate).not_to be_valid  # Agora o Rails saberá que o email já existe
    expect(user_duplicate.errors[:email]).to include("has already been taken")
  end


  it "pode ser admin ou não" do
    subject.admin = true
    expect(subject.admin).to be true

    subject.admin = false
    expect(subject.admin).to be false
  end
end
