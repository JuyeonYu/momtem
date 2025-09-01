class CommentsController < ApplicationController
  before_action :require_login, only: [:create]

  def index
    @comments = Comment.all
  end

  def create
    Rails.logger.info("[Comments#create] params=#{params.to_unsafe_h}")
    parent = find_commentable!
    @comment = parent.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to parent, notice: '댓글이 등록되었습니다.', status: :see_other
    else
      # Render the appropriate show template based on parent type
      template = "#{parent.model_name.collection}/show"
      instance_variable_set("@#{parent.model_name.singular}", parent)
      render template, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable!
    if params[:recommand_item_id]
      RecommandItem.find(params[:recommand_item_id])
    elsif params[:review_id]
      Review.find(params[:review_id])
    elsif params[:bamboo_id]
      Bamboo.find(params[:bamboo_id])
    else
      raise ActiveRecord::RecordNotFound, "Missing parent for comment"
    end
  end
end
