# app/services/withdraw_service.rb
class WithdrawService
  def initialize(account, value)
    @account = account
    @value = value.to_d
    @current_value = @account.value_account - @value
  end

  def execute
    return { message: "valor precisa ser positivo" } if @value < 0
    return { message: "Saque maior que valor presente na conta" } if invalid_withdrawal?

    if process_withdrawal
      {
        value: @account,
        movimentação: create_movement,
        message: "Saque realizado com sucesso",
        status: :ok
      }
    else
      {
        message: "Saque não realizado",
        error: @account.errors,
        status: :unprocessable_entity
      }
    end
  end

  private

  def invalid_withdrawal?
    !@account.vip && @current_value < 0
  end

  def process_withdrawal
    @account.update_column(:value_account, @current_value)
  end

  def create_movement
    Movimentation.create(
      account_number: @account.number,
      description: "Saque",
      value: -@value
    )
  end
end
