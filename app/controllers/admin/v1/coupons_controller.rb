module Admin
  module V1
    class CouponsController < ApiController
      def index
        @coupons = Coupon.all
      end
    end
  end
end
