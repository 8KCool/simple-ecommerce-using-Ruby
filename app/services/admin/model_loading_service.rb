module Admin
  class ModelLoadingService
    attr_reader :records, :pagination

    def initialize(searcheable_model, params = {})
      @searcheable_model = searcheable_model
      @params = params || {}
      @records = []
      @pagination = { page: @params[:page].to_i, length: @params[:length].to_i }
    end

    def call
      fix_pagination_values
      filtered = @searcheable_model.search_by_name(@params.dig(:search, :name))
      @records = filtered.order(@params[:order].to_h)
                         .paginate(@pagination[:page], @pagination[:length])

      total_pages = (filtered.count / @pagination[:length].to_f).ceil
      @pagination.merge!(total: filtered.count, total_pages: total_pages)
    end

    private

    def fix_pagination_values
      @pagination[:page] = @searcheable_model.model::DEFAULT_PAGE if @pagination[:page] <= 0
      @pagination[:length] = @searcheable_model.model::MAX_PER_PAGE if @pagination[:length] <= 0
    end
  end
end