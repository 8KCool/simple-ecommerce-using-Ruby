require 'rails_helper'

RSpec.describe 'Admin::V1::Licenses', type: :request do
  let(:user) { create(:user) }

  context 'GET /licenses' do
    let(:url) { '/admin/v1/licenses' }
    let!(:licenses) { create_list(:license, 10) }

    context 'without any params' do
      it 'returns 10 Licenses' do
        get url, headers: auth_header(user)
        expect(body_json['licenses'].count).to eq 10
      end

      it 'returns 10 first Licenses' do
        get url, headers: auth_header(user)
        expected_licenses = licenses[0..9].map do |license|
          build_license_json(license)
        end

        expect(body_json['licenses']).to contain_exactly(*expected_licenses)
      end

      it 'returns success status' do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with pagination params' do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it 'returns records sized by :length' do
        get url, headers: auth_header(user), params: pagination_params
        expect(body_json['licenses'].count).to eq length
      end

      it 'returns licenses limited by pagination' do
        get url, headers: auth_header(user), params: pagination_params
        expected_licenses = licenses[5..9].map do |license| 
          build_license_json(license)
        end
        expect(body_json['licenses']).to contain_exactly(*expected_licenses)
      end

      it 'returns success status' do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  def build_license_json(object)
    json = object.as_json(only: [:id, :key])
    json['game'] = object.game.as_json(only: %i(mode release_date developer))
    json['user'] = object.user.as_json(only: %i(id name email profile))
    json
  end
end
