# app/jobs/fetch_og_job.rb
class FetchOgJob < ApplicationJob
  queue_as :default
  def perform(recommand_item_id)
    item = RecommandItem.find_by(id: recommand_item_id)
    item&.fetch_and_cache_og!
  end
end