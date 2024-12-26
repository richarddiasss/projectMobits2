class MovimentationsController < ApplicationController
  before_action :authorize
  before_action :set_movimentation, only: %i[ show destroy]

  # GET /movimentations
  def index
    @movimentations = Movimentation.all

    render json: @movimentations
  end

  # GET /movimentations/1
  def show
    render json: @movimentation
  end

  def transations
    @movimentation = Movimentation.where(account_number: @account.number)
    render json: @movimentation
  end

  # POST /movimentations
  def create
    @movimentation = Movimentation.new(movimentation_params)

    if @movimentation.save
      render json: @movimentation, status: :created, location: @movimentation
    else
      render json: @movimentation.errors, status: :unprocessable_entity
    end
  end


  # DELETE /movimentations/1
  def destroy
    @movimentation.destroy!
  end

  def destroyall
    Movimentation.delete_all
  end

  def transfer
    tax_user_normal = 8
    tax_user_vip = 0.008
    values = params.permit(:value, :number_destiny) # Filtra os parâmetros permitidos
    value_transfer = values[:value].to_f
    number_destiny = values[:number_destiny].to_i

    if @account.number == number_destiny
      return render json: { message: "inválido realizar transferência para si mesmo." }
    end
    if @account.vip
      if (value_transfer + (tax_user_vip*value_transfer)) > @account.value_account
        render json: { message: "Saldo insuficiente para realizar a transferência (incluindo taxa)." }
      else
        movimentation_tranfer(value_transfer, number_destiny, (tax_user_vip*value_transfer))
      end
    else
      if (value_transfer + tax_user_normal) > @account.value_account || value_transfer > 1000
        render json: { message: "Valor excede o limite de R$ 1.000,00 ou saldo insuficiente." }
      else
        movimentation_tranfer(value_transfer, number_destiny, tax_user_normal)
      end

    end
  end


  private

    def movimentation_tranfer(value_tranfer, number_destiny, tax_user)
      # update do usuario que enviou e criação da movimentação no extrato
      user_destiny = exist_user(number_destiny)
      if !user_destiny
        return render json: { message: "Conta destino não encontrada.", status: 404 }
      end
      user_destiny.update_column(:value_account, user_destiny.value_account + value_tranfer)
      movimentation_origin = Movimentation.create(
        account_number: user_destiny.number,
        description: "Transferência enviada por #{@account.name}",
        value: value_tranfer,

      )
      @account.update_column(:value_account, @account.value_account - (value_tranfer + tax_user))
      movimentation_destiny = Movimentation.create(
        account_number: @account.number,
        description: "Transferencia feita para #{user_destiny.name}",
        value: value_tranfer,
        tax: tax_user
      )

      render json: { movimentation_origin: movimentation_origin, movimentation_destiny: movimentation_destiny, message: "Transferência realizada com sucesso!" }
    end

    def exist_user(number)
      account = Account.find_by(number: number)
      account
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_movimentation
      @movimentation = Movimentation.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movimentation_params
      params.expect(movimentation: [ :value, :description ]).merge(account_id: @account.id)
    end
end
