class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @reviews = Review.where(user_id: @user.id).order(created_at: :desc)
    @bamboos = Bamboo.where(user_id: @user.id).order(created_at: :desc)
    @recommand_items = RecommandItem.where(user_id: @user.id).order(created_at: :desc)
    @comments = Comment.where(user_id: @user.id).includes(:commentable).order(created_at: :desc)
  end

  def update
    if current_user.update(user_params)
      redirect_to my_page_path, notice: '닉네임이 변경되었습니다.'
    else
      @user = current_user
      @reviews = Review.where(user_id: @user.id).order(created_at: :desc)
      @bamboos = Bamboo.where(user_id: @user.id).order(created_at: :desc)
      @recommand_items = RecommandItem.where(user_id: @user.id).order(created_at: :desc)
      @comments = Comment.where(user_id: @user.id).includes(:commentable).order(created_at: :desc)
      flash.now[:alert] = '닉네임 변경에 실패했습니다.'
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname)
  end
end
