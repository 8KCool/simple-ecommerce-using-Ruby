shared_examples 'pagination meta attributes' do |pagination_attr|
  it 'returns :meta attributes with right pagination data' do
    pagination_attr.stringify_keys!
    expect(body_json['meta']).to include(pagination_attr)
  end
end
