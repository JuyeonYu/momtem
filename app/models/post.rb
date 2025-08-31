class Post < ApplicationRecord
  delegated_type :postable, types: %w[Review RecommandItem Bamboo], dependent: :destroy
end
