module Admin
  class ModelLoadingService
    def initialize(searcheable_model, params = {})
      @searcheable_model = searcheable_model
      @params = params || {}
    end

    def call
      @searcheable_model.search_by_name(@params.dig(:search, :name))
                        .order(@params[:order].to_h)
                        .paginate(@params[:page].to_i, @params[:length].to_i)
    end
  end
end