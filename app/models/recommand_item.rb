class RecommandItem < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  def fetch_and_cache_og!
    return if link.blank?

    preview = LinkThumbnailer.generate(
      link,
      attributes: %i[title description images],
      image_limit: 1,
      http_timeout: 30,
      redirect_limit: 3
    )

    self.og_title = preview&.title
    self.og_description = preview&.description
    self.og_image = preview&.images&.first&.src&.to_s
    save! if persisted?
    self
  rescue StandardError => e
    Rails.logger.warn("[og] fetch failed for #{link}: #{e.class} - #{e.message}")
    self
  end

  has_many :comments, as: :commentable, dependent: :destroy
  has_one :post, as: :postable, dependent: :destroy

  after_create :create_post_record

  private

  def create_post_record
    create_post!
  end
end
