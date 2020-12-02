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

  context 'POST /licenses' do
    let(:url) { '/admin/v1/licenses' }

    context 'with valid params' do
      let(:game) { create(:game) }
      let(:license_params) do
        {
          license: attributes_for(:license).merge(game_id: game.id, user_id: user.id)
        }.to_json
      end

      it 'adds a new license' do
        expect do
          post url, headers: auth_header(user), params: license_params
        end.to change(License, :count).by(1)
      end

      it 'returns last added license' do
        post url, headers: auth_header(user), params: license_params
        expect_license = build_license_json(License.last)
        expect(body_json['license']).to eq(expect_license)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:license_invalid_params) do
        { license: attributes_for(:license, game_id: nil) }.to_json
      end

      it 'does not add a new license' do
        expect do
          post url, headers: auth_header(user), params: license_invalid_params
        end.to_not change(License, :count)
      end

      it 'returns error messages' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['errors']['fields']).to have_key('game')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'GET /license/:id' do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it 'returns requested license' do
      get url, headers: auth_header(user)
      expect_license = build_license_json(license)
      expect(body_json['license']).to eq(expect_license)
    end

    it 'returns success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'PATCH  /licenses/:id' do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    context 'with valid params' do
      let(:new_key) { SecureRandom.uuid }
      let(:license_params) { { license: { key: new_key } }.to_json }

      it 'updates license' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect(license.key).to eq(new_key)
      end

      it 'returns updated license' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect_category = build_license_json(license)
        expect(body_json['license']).to eq(expect_category)
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:license_invalid_params) do
        { license: attributes_for(:license, key: nil) }.to_json
      end

      it 'does not update license' do
        old_key = license.key
        patch url, headers: auth_header(user), params: license_invalid_params
        license.reload
        expect(license.key).to eq(old_key)
      end

      it 'returns error messages' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['errors']['fields']).to have_key('key')
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
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
