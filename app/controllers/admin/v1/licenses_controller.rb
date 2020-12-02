module Admin
  module V1
    class LicensesController < ApiController
      before_action :load_license, only: %i(show update destroy)

      def index
        @licenses = load_licenses
      end

      def create
        @license = License.new
        @license.attributes = license_params
        save_license!
      end

      def show; end

      def update
        @license.attributes = license_params
        save_license!
      end

      private

      def load_licenses
        License.all.paginate(params[:page].to_i, params[:length].to_i)
      end

      def load_license
        @license = License.find(params[:id])
      end

      def license_params
        params.require(:license).permit(:key, :game_id, :user_id)
      end

      def save_license!
        @license.save!
        render :show
      rescue
        render_error(fields: @license.errors.messages)
      end
    end
  end
end
