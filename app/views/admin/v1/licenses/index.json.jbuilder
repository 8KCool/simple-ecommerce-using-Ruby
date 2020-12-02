json.licenses do
  json.array! @licenses do |license|
    json.partial! license
  end
end