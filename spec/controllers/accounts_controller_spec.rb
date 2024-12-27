require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:account) { create(:account) }
  let(:token) { JWT.encode({ account_number: account.number }, 'secret') }

  describe 'POST #create' do
    let(:valid_params) { { name: "John Doe", password: "password123", vip: false } }

    it 'creates account with valid params' do
      post :create, params: valid_params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include('token', 'account')
    end

    it 'returns error with invalid params' do
      post :create, params: { name: nil, password: nil }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST #login' do
    before { account }

    context 'with valid credentials' do
      it 'returns token and account' do
        post :login, params: { number: account.number, password: account.password }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('token', 'account')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized' do
        post :login, params: { number: account.number, password: 'wrong' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #get_value' do
    before { request.headers['Authorization'] = "Bearer #{token}" }

    it 'returns account value' do
      get :get_value
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['value']).to eq(account.value_account)
    end
  end

  describe 'POST #saque' do
    before { request.headers['Authorization'] = "Bearer #{token}" }

    context 'with sufficient funds' do
      before { account.update(value_account: 1000) }

      it 'processes withdrawal' do
        post :saque, params: { value: 500 }
        expect(response).to have_http_status(:success)
        account.reload
        expect(account.value_account).to eq(500)
      end
    end

    context 'with insufficient funds' do
      it 'returns error' do
        post :saque, params: { value: 1000 }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #deposit' do
    before { request.headers['Authorization'] = "Bearer #{token}" }

    it 'processes deposit' do
      post :deposit, params: { value: 500 }
      expect(response).to have_http_status(:success)
      account.reload
      expect(account.value_account).to eq(500)
    end

    it 'rejects negative deposits' do
      post :deposit, params: { value: -100 }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST #visit' do
    before { request.headers['Authorization'] = "Bearer #{token}" }

    context 'when account is VIP with sufficient funds' do
      before { account.update(vip: true, value_account: 100) }

      it 'processes visit successfully' do
        post :visit
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['success']).to be true
      end
    end

    context 'when not VIP' do
      before { account.update(vip: false) }

      it 'returns error' do
        post :visit
        expect(JSON.parse(response.body)['success']).to be false
      end
    end
  end
end
