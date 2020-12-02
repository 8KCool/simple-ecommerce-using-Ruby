module Admin
  module V1
    class LicensesController < ApiController
      def index
        @licenses = load_licenses
      end

      private

      def load_licenses
        License.all.paginate(params[:page].to_i, params[:length].to_i)
      end
    end
  end
end
