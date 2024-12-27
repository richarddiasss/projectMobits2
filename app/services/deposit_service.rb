class DepositService
  def initialize(account)
    @account = account
  end

  def execute(value:)
    amount = value.to_d
    return { message: "valor precisa ser positivo" } if amount < 0

    # garante que múltiplas operações no banco de dados sejam tratadas como uma única unidade atômica.
    ActiveRecord::Base.transaction do
      current_value = @account.value_account + amount

      if @account.update_column(:value_account, current_value)
        movimentation = create_movimentation(amount)
        {
          account: @account,
          movimentation: movimentation,
          message: "deposito feito com sucesso",
          status: :ok
        }
      else
        { message: "depósito não realizado", erro: @account.errors }
      end
    end
  end

  private

  def create_movimentation(amount)
    Movimentation.create(
      account_number: @account.number,
      description: "Depósito",
      value: amount
    )
  end
end
