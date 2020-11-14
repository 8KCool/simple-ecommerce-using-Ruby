json.coupons do
  json.array! @coupons, :id, :code, :status, :discount_value, :due_date
end