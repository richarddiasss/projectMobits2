# app/controllers/dashboard_controller.rb
class PagesController < ApplicationController
  def login
    render "login"
  end

  def register
    render "register"
  end

  def balance
    render "balance"
  end

  def deposit
    render "deposit"
  end

  def saque
    render "saque"
  end

  def transations
    render "transations"
  end

  def transfer
    render "transfer"
  end

  def visit
    render "visit"
  end
end
