class Bamboo < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_one :post, as: :postable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  after_create :create_post_record

  validates :body, presence: true

  private

  def create_post_record
    create_post!
  end
end
