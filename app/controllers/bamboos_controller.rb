class BamboosController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :set_bamboo, only: [:show]

  def index
    @bamboos = Bamboo.order(created_at: :desc)
  end

  def new
    @bamboo = Bamboo.new
  end

  def create
    @bamboo = Bamboo.new(bamboo_params)
    @bamboo.user = current_user
    if @bamboo.save
      redirect_to @bamboo, notice: '대나무숲 글이 등록되었습니다.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_bamboo
    @bamboo = Bamboo.find(params[:id])
  end

  def bamboo_params
    params.require(:bamboo).permit(:title, :body)
  end
end
