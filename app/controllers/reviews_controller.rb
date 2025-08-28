class ReviewsController < ApplicationController
    def index
        @reviews = Review.with_rich_text_body_and_embeds
    end

    def new
        @review = Review.new
    end

    def create
        @review = Review.new(review_params)
        if @review.save
            redirect_to reviews_path, notice: "리뷰가 작성되었습니다."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @review = Review.find(params[:id])
    end

    private 

    def review_params
        params.require(:review).permit(:title, :body)
    end
end
