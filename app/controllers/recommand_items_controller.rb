class RecommandItemsController < ApplicationController
    before_action :set_recommand_item, only: [:show]

    def index
          @item_types = RecommandItem.distinct.pluck(:item_type).compact

  scope = RecommandItem.all
  scope = scope.where(item_type: params[:filter]) if params[:filter].present?
  @recommand_items = scope.order(created_at: :desc)

    end
    
    def show
    end


    private

    def set_recommand_item
        @recommand_item = RecommandItem.find(params[:id])
    end

    def recommand_item_params
        params.require(:recommand_item).permit(:title, :body, :link, :item_type)
    end

    
end
