class VisitService
  def initialize(account)
    @account = account
    @price_visit = 50
  end

  def execute
    return failure_response("O usuário precisa ser vip para requisitar essa opção.") unless @account.vip
    return failure_response("não possui dinheiro para a visita técnica") if insufficient_funds?

    process_visit
  end

  private

  def insufficient_funds?
    @account.value_account < @price_visit
  end

  def process_visit
    if @account.update_column(:value_account, @account.value_account - @price_visit)
      movimentation = create_movimentation
      success_response(movimentation)
    else
      failure_response("Visita não realizada", @account.errors)
    end
  end

  def create_movimentation
    Movimentation.create(
      account_number: @account.number,
      description: "Visita do gerente",
      value: @price_visit
    )
  end

  def success_response(movimentation)
    {
      success: true,
      message: "Visita realizada com sucesso",
      movimentation: movimentation
    }
  end

  def failure_response(message, errors = nil)
    response = { success: false, message: message }
    response[:error] = errors if errors
    response
  end
end
