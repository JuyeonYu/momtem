class RecommandItem < ApplicationRecord
def fetch_and_cache_og!
    return if link.blank?

    preview = LinkThumbnailer.generate(
        link,
        attributes: [:title, :description, :images],
        image_limit: 1,
        http_timeout: 30,
        redirect_limit: 3
    )

    self.og_title = preview&.title
    self.og_description = preview&.description
    self.og_image = preview&.images.first&.scr&.to_s
    self! if persisted?
    self
rescue => e
    Rails.logger.warn("[og] fetch failed for #{link}: #{e.class} - #{e.message}")
    self
end

end
