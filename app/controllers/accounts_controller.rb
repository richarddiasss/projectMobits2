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
          render json: { message: "numero da conta ou senha inválidos", errors: @account.errors },
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
    result = WithdrawService.new(@account, params[:value]).execute
    render json: result, status: (result[:status] || :unprocessable_entity)
  end

  def deposit
    result = DepositService.new(@account).execute(value: params[:value])
    render json: result, status: result[:status] || :unprocessable_entity
  end

  def visit
    service = VisitService.new(@account)
    render json: service.execute
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
