class LikesController < ApplicationController
  before_action :require_login
  before_action :set_likeable

  def create
    Like.find_or_create_by!(user: current_user, likeable: @likeable)
    redirect_to likeable_redirect_target, notice: '좋아요를 눌렀습니다.', status: :see_other
  end

  def destroy
    like = Like.find_by(user: current_user, likeable: @likeable)
    like&.destroy
    redirect_to likeable_redirect_target, notice: '좋아요를 취소했습니다.', status: :see_other
  end

  private

  def set_likeable
    @likeable =
      if params[:review_id]
        Review.find(params[:review_id])
      elsif params[:recommand_item_id]
        RecommandItem.find(params[:recommand_item_id])
      elsif params[:bamboo_id]
        Bamboo.find(params[:bamboo_id])
      elsif params[:comment_id]
        Comment.find(params[:comment_id])
      else
        # Fallback for polymorphic request via query params
        type = params[:likeable_type]
        id = params[:likeable_id]
        raise ActiveRecord::RecordNotFound, 'Missing likeable' if type.blank? || id.blank?
        type.constantize.find(id)
      end
  end

  def likeable_redirect_target
    return @likeable.commentable if @likeable.is_a?(Comment)
    @likeable
  end
end
