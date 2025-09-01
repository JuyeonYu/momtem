class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @reviews = Review.where(user_id: @user.id).order(created_at: :desc)
    @bamboos = Bamboo.where(user_id: @user.id).order(created_at: :desc)
    @recommand_items = RecommandItem.where(user_id: @user.id).order(created_at: :desc)
    @comments = Comment.where(user_id: @user.id).includes(:commentable).order(created_at: :desc)
  end
end

