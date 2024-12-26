Rails.application.routes.draw do
  resources :movimentations
  get "/transations", to: "movimentations#transations"
  post "/transfer", to: "movimentations#transfer"
  delete "/destroyall", to: "movimentations#destroyall"

  resources :accounts
  get "/account", to: "accounts#getAccount"

   # Rotas de sessão
   root "pages#login"
   post "/login", to: "accounts#login"

  # Rotas de criação de conta
  get "/signup", to: "pages#register"
  post "/accounts", to: "accounts#create"

  # rota menu
  get "/menu", to: "pages#menu"

  # rotas opções menu
  get "/balance", to: "pages#balance"
  get "/getValue", to: "accounts#get_value"

  get "/deposit", to: "pages#deposit"
  post "/deposit", to: "accounts#deposit"

  get "/saque", to: "pages#saque"
  post "/saque", to: "accounts#saque"

  get "/lookTransations", to: "pages#transations"
  get "/transations", to: "movimentations#transations"

  get "/transfer", to: "pages#transfer"
  post "/transfer", to: "movimentations#transfer"

  get "/visit", to: "pages#visit"
  post "/visit", to: "accounts#visit"

  delete "/destroyUsers", to: "accounts#destroyUsers"
end
