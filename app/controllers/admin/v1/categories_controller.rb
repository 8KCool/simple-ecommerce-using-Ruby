module Admin
  module V1
    class CategoriesController < ApiController
      before_action :load_category, only: [:update, :destroy, :show]

      def index
        @loading_service = Admin::ModelLoadingService.new(Category.all, searchable_params)
        @loading_service.call
      end

      def create
        @category = Category.new
        @category.attributes = category_params
        save_category!
      end

      def show; end

      def update
        @category.attributes = category_params
        save_category!
      end

      def destroy
        @category.destroy!
      rescue
        render_error(fields: @category.errors.messages)
      end

      private

      def searchable_params
        params.permit({ search: :name }, { order: [] }, :page, :length)
      end

      def load_category
        @category = Category.find(params[:id])
      end

      def category_params
        return unless params.key?(:category)

        params.require(:category).permit(:name)
      end

      def save_category!
        @category.save!
        render :show
      rescue
        render_error(fields: @category.errors.messages)
      end
    end
  end
end