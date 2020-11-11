module Admin
  module V1
    class ApiController < ApplicationController
      include Authenticable

      def render_error(message: nil, fields: nil, status: :unprocessable_entity)
        errors = {}
        errors['fields'] = fields if fields.present?
        errors['message'] = fields if message.present?

        render json: { errors: errors }, status: status
      end
    end
  end
end
