module Admin
  module V1
    class SystemRequirementsController < ApiController
      def index
        @system_requirements = SystemRequirement.all
      end
    end
  end
end
