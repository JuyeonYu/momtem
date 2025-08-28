class Review < ApplicationRecord
  has_rich_text :body

  # 리치텍스트 본문에서 첫 번째 이미지 Blob 추출
  def first_image_blob
    content = body&.body
    return nil unless content

    # attachables 중 ActiveStorage::Blob 타입만 골라서 첫 번째 이미지 반환
    content.attachables.grep(ActiveStorage::Blob).find(&:image?)
  end
end
