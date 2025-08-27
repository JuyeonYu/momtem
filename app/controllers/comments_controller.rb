class CommentsController < ApplicationController
  before_action :set_comment_item, only: [:show]

  def index
    @comments = Comment.all
  end

  def create
    @recommand_item = RecommandItem.find(params[:recommand_item_id])
    @comment = @recommand_item.comments.build(comment_params)

    if @comment.save
      redirect_to @recommand_item, notice: '댓글이 등록되었습니다.'
    else
      redirect_to @recommand_item, alert: '댓글 내용을 입력해주세요.'
    end
  end

  private

  def set_comment_item
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
