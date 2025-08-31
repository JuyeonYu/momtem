class Bamboo < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_one :post, as: :postable, dependent: :destroy

  after_create :create_post_record

  validates :body, presence: true

  private

  def create_post_record
    create_post!
  end
end

