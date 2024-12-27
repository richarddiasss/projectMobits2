class TransferService
  TAX_NORMAL = 8
  TAX_VIP = 0.008

  def initialize(origin_account)
    @origin_account = origin_account
  end

  def execute(value:, number_destiny:)
    value = value.to_f
    number_destiny = number_destiny.to_i

    return { message: "valor transferido precisa ser positivo" } if value < 0
    return { message: "inválido realizar transferência para si mesmo." } if @origin_account.number == number_destiny

    if @origin_account.vip
      process_vip_transfer(value, number_destiny)
    else
      process_normal_transfer(value, number_destiny)
    end
  end

  private

  def process_vip_transfer(value, number_destiny)
    tax = TAX_VIP * value
    total = value + tax

    if total > @origin_account.value_account
      { message: "Saldo insuficiente para realizar a transferência (incluindo taxa)." }
    else
      execute_transfer(value, number_destiny, tax)
    end
  end

  def process_normal_transfer(value, number_destiny)
    if (value + TAX_NORMAL) > @origin_account.value_account || value > 1000
      { message: "Valor excede o limite de R$ 1.000,00 ou saldo insuficiente." }
    else
      execute_transfer(value, number_destiny, TAX_NORMAL)
    end
  end

  def execute_transfer(value, number_destiny, tax)
    ActiveRecord::Base.transaction do
      destiny_account = Account.find_by(number: number_destiny)
      return { message: "Conta destino não encontrada.", status: 404 } unless destiny_account

      destiny_account.update_column(:value_account, destiny_account.value_account + value)
      @origin_account.update_column(:value_account, @origin_account.value_account - (value + tax))

      movimentation_origin = create_movimentation(destiny_account.number,
        "Transferência enviada por #{@origin_account.name}", value)

      movimentation_destiny = create_movimentation(@origin_account.number,
        "Transferência feita para #{destiny_account.name}", value, tax)

      {
        movimentation_origin: movimentation_origin,
        movimentation_destiny: movimentation_destiny,
        message: "Transferência realizada com sucesso!"
      }
    end
  end

  def create_movimentation(account_number, description, value, tax = nil)
    Movimentation.create(
      account_number: account_number,
      description: description,
      value: value,
      tax: tax
    )
  end
end
