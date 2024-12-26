class Account < ApplicationRecord
  self.primary_key = "number"
  has_many :movimentations, foreign_key: "account_number"
  # flag utilizada pelo bcrypt para realizar a criptografia da senha
  has_secure_password

    # validações
    validates :number, presence: true, uniqueness: true
    validates :password, presence: true, format: { with: /\A\d{4}\z/, message: "deve conter exatamente 4 dígitos numéricos" }
    validates :name, presence: true
end
