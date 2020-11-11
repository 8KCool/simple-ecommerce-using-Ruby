require 'rails_helper'

RSpec.describe 'Admin::V1::Categories', type: :request do
  let(:user) { create(:user) }

  context 'GET /categories' do
    let(:url) { '/admin/v1/categories' }
    let!(:categories) { create_list(:category, 5) }

    it 'returns all categories' do
      get url, headers: auth_header(user)
      expect(body_json['categories']).to contain_exactly(*categories.as_json(only: %i(id name))) 
    end

    it 'returns success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /categories' do
    let(:url) { '/admin/v1/categories' }

    context 'with valid params' do
      let(:category_params) { { category: attributes_for(:category) }.to_json }

      it 'adds a new category' do
        expect do
          post url, headers: auth_header(user), params: category_params
        end.to change(Category, :count).by(1)
      end

      it 'returns last added category' do
        post url, headers: auth_header(user), params: category_params
        expect_category = Category.last.as_json(only: %i(id name))
        expect(body_json['category']).to eq(expect_category)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:category_invalid_params) do
        { category: attributes_for(:category, name: nil) }.to_json
      end

      it 'does not add a new Category' do
        expect do
          post url, headers: auth_header(user), params: category_invalid_params
        end.to_not change(Category, :count)
      end

      it 'returns error messages' do
        post url, headers: auth_header(user), params: category_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: category_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH  /categories/:id' do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    context 'with valid params' do
      let(:new_name) { 'My new name' }
      let(:category_params) { { category: { name: new_name } }.to_json }

      it 'updates category' do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect(category.name).to eq(new_name)
      end

      it 'returns updated category' do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect_category = category.as_json(only: %i(id name))
        expect(body_json['category']).to eq(expect_category)
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:category_invalid_params) do
        { category: attributes_for(:category, name: nil) }.to_json
      end

      it 'does not update Category' do
        old_name = category.name
        patch url, headers: auth_header(user), params: category_invalid_params
        category.reload
        expect(category.name).to eq(old_name)
      end

      it 'returns error messages' do
        patch url, headers: auth_header(user), params: category_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: category_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /categories/:id' do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    it 'removes category' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Category, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end

    it 'removes all associated product categories' do
      product_categories = create_list(:product_category, 3, category: category)
      delete url, headers: auth_header(user)
      expected_product_categories = ProductCategory.where(id: product_categories.pluck(:id))
      expect(expected_product_categories).to eq([])
    end
  end
end
