require 'rails_helper'

RSpec.describe 'Admin::V1::Coupons as :admin', type: :request do
  let(:user) { create(:user) }

  context 'GET /coupons' do
    let(:url) { '/admin/v1/coupons' }
    let!(:coupons) { create_list(:coupon, 3) }

    it 'returns all coupons' do
      get url, headers: auth_header(user)
      expect(body_json['coupons']).to contain_exactly(*coupons.as_json(only: %i(id name code status discount_value max_use due_date)))  
    end

    it 'returns success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end
end
