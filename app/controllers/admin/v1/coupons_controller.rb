module Admin
  module V1
    class CouponsController < ApiController
      def index
        @coupons = Coupon.all
      end

      def create
        @coupon = Coupon.new
        @coupon.attributes = coupon_params
        save_coupon!
      end

      private

      def save_coupon!
        @coupon.save!
        render :show
      rescue
        render_error(fields: @coupon.errors.messages)
      end

      def coupon_params
        return unless params.key?(:coupon)

        params.require(:coupon).permit(:code, :status, :discount_value, :due_date)
      end
    end
  end
end
