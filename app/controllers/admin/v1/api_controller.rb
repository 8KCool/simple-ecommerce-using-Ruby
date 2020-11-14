module Admin
  module V1
    class ApiController < ApplicationController
      class ForbiddenAccess < StandardError; end

      include Authenticable
      include SimpleErrorRenderable
      self.simple_error_partial = 'shared/simple_error'

      before_action :restrict_access_for_admin!

      rescue_from ForbiddenAccess do
        render_error(message: 'Forbidden access', status: :forbidden)
      end

      private

      def restrict_access_for_admin!
        raise ForbiddenAccess unless current_user.admin?
      end
    end
  end
end
