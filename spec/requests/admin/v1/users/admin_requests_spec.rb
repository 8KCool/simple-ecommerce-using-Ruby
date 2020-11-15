require 'rails_helper'

RSpec.describe 'Admin::V1::Users as :admin', type: :request do
  let(:user) { create(:user) }

  context 'GET /users' do
    let(:url) { '/admin/v1/users' }
    let!(:users) { create_list(:user, 5) }

    it 'returns all users' do
      get url, headers: auth_header(user)
      expect(body_json['users']).to contain_exactly(*users.push(user).as_json(only: %i(id name email profile))) 
    end

    it 'returns success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end
end
