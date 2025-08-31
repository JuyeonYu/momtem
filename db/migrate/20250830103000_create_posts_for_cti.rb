class CreatePostsForCti < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :postable_type, null: false
      t.bigint :postable_id, null: false
      t.timestamps
    end

    add_index :posts, [:postable_type, :postable_id], unique: true
  end
end

