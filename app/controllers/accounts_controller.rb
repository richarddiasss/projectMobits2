class AccountsController < ApplicationController
  include ActionController::MimeResponds  # Adiciona o módulo necessário
  before_action :authorize, only: [ :get_value, :deposit, :saque, :visit, :getAccount ]

  def getAccount
      render json: @account
  end

  def destroyUsers
      Account.delete_all
  end

  def create
      @account = Account.create(account_params_create_account)
      if @account.valid?
          token = encode_token({ account_number: @account.number })
          render json: { token: token, account: @account }
      else
          render json: { error: "numero da conta ou senha inválidos", erros: @account.errors },
          status: :unprocessable_entity

      end
  end

  def login
      @account = Account.find_by(number: account_params_login[:number])
      if @account && @account.authenticate(account_params_login[:password])
        token = encode_token({ account_number: @account.number })
        render json: { account: @account, token: token }, status: :ok
      else
        render json: { message: "número da conta ou senha inválidos", error: @account.errors }, status: :unauthorized
      end
  end

  def get_value
    render json: { value: @account.value_account }
  end

  def saque
      value_retired = params[:value].to_d
      current_value = @account.value_account - value_retired
      if value_retired < 0
        return  render json: { message: "valor precisa ser positivo" }
      end

      if !(@account.vip)
        if current_value < 0
          return render json: { message: "Saque maior que valor presente na conta" }
        end
      end
      if @account.update_column(:value_account, current_value)
        movimentation = Movimentation.create(
        account_number: @account.number,
        description: "Saque",
        value: value_retired
        )
        render json: { value: @account, movimentação: movimentation, message: "Saque realizado com sucesso" }, status: :ok
      else
        render json: { message: "Saque não realizado", error: @account.errors }, status: :unprocessable_entity
      end
  end

  def deposit
      amount_deposited = params[:value].to_d
      current_value = @account.value_account + amount_deposited

      if amount_deposited < 0
        return  render json: { message: "valor precisa ser positivo" }
      end

      if @account.update_column(:value_account, current_value)
          movimentation = Movimentation.create(
              account_number: @account.number,
              description: "Depósito ",
              value: amount_deposited
          )
          render json: { account: @account, movimentation: movimentation, message: "deposito feito com sucesso" },
                      status: :ok
      else
          render json: { messagem: "depósito não realizado", erro: @account.errors }
      end
  end

  def visit
      price_vist = 50
      # Primeiro, validamos o VIP
      unless @account.vip
        return render json: { message: "O usuário precisa ser vip para requisitar essa opção." }
      end

      # Depois, validamos o saldo
      if @account.value_account < price_vist
        return render json: { message: "não possui dinheiro para a visita técnica" }
      end

      # Por fim, realizamos a transação
      if @account.update_column(:value_account, @account.value_account - price_vist)
        movimentation = Movimentation.create(
          account_number: @account.number,
          description: "Visita do gerente",
          value: price_vist
        )
        render json: { message: "Visita realizada com sucesso", movimentation: movimentation }
      else
        render json: { message: "Visita não realizada", error: @account.errors }
      end
  end


  private

  def account_params_create_account
      number = get_number()
      params.permit(:name, :vip, :password).merge(value_account: 0, number: number)
  end

  def account_params_login
      params.permit(:number, :name, :vip, :password, :value_account)
  end
  def get_number
      loop do
        number = Random.rand(10000..99999)
        return number unless Account.find_by(number: number)
      end
  end
end
