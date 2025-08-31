class Review < ApplicationRecord
  has_rich_text :body

  # 리치텍스트 본문에서 첫 번째 이미지 Blob 추출
  def first_image_blob
    content = body&.body
    return nil unless content

    # attachables 중 ActiveStorage::Blob 타입만 골라서 첫 번째 이미지 반환
    content.attachables.grep(ActiveStorage::Blob).find(&:image?)
  end

    has_many :comments, as: :commentable, dependent: :destroy
    has_one :post, as: :postable, dependent: :destroy

    after_create :create_post_record

    private

    def create_post_record
      create_post!
    end

end
