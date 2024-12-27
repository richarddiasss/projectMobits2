class MovimentationsController < ApplicationController
  before_action :authorize

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

  def destroyall
    Movimentation.delete_all
  end

  def transfer
    result = TransferService.new(@account).execute(
      value: params[:value],
      number_destiny: params[:number_destiny]
    )
    render json: result
  end


  private

    # Only allow a list of trusted parameters through.
    def movimentation_params
      params.expect(movimentation: [ :value, :description ]).merge(account_id: @account.id)
    end
end
