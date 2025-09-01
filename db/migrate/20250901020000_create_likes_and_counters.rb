class CreateLikesAndCounters < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :likeable_type, null: false
      t.bigint :likeable_id, null: false
      t.timestamps
    end
    add_index :likes, [:likeable_type, :likeable_id]
    add_index :likes, [:user_id, :likeable_type, :likeable_id], unique: true, name: 'index_likes_on_user_and_likeable'

    # Counter caches for likes
    add_column :reviews, :likes_count, :integer, null: false, default: 0
    add_column :recommand_items, :likes_count, :integer, null: false, default: 0
    add_column :bamboos, :likes_count, :integer, null: false, default: 0
    add_column :comments, :likes_count, :integer, null: false, default: 0

    # Counter caches for comments on content models
    add_column :reviews, :comments_count, :integer, null: false, default: 0
    add_column :recommand_items, :comments_count, :integer, null: false, default: 0
    add_column :bamboos, :comments_count, :integer, null: false, default: 0
  end
end

