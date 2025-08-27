class Comment < ApplicationRecord
  belongs_to :recommand_item

  validates :body, presence: true
end
