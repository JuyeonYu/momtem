class CommentsController < ApplicationController

  def index
    @comments = Comment.all
  end

  def create
    Rails.logger.info("[Comments#create] params=#{params.to_unsafe_h}")
    @recommand_item = RecommandItem.find(params[:recommand_item_id])
    @comment = @recommand_item.comments.build(comment_params)

    if @comment.save
      redirect_to @recommand_item, notice: '댓글이 등록되었습니다.', status: :see_other
    else
      render 'recommand_items/show', status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
