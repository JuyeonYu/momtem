class RecommandItemsController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :set_recommand_item, only: [:show]

  def index
    @item_types = RecommandItem.distinct.pluck(:item_type).compact

    scope = RecommandItem.all
    scope = scope.where(item_type: params[:filter]) if params[:filter].present?
    @recommand_items = scope.order(created_at: :desc)
  end

  def show; end

  def new
    @recommand_item = RecommandItem.new
  end

  def create
    @recommand_item = RecommandItem.new(recommand_item_params)
    @recommand_item.user = current_user
    if @recommand_item.save
      redirect_to @recommand_item, notice: '국민템이 등록되었습니다.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_recommand_item
    @recommand_item = RecommandItem.find(params[:id])
  end

  def recommand_item_params
    params.require(:recommand_item).permit(:title, :body, :link, :item_type)
  end
end
