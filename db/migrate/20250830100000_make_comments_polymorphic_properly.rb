class MakeCommentsPolymorphicProperly < ActiveRecord::Migration[8.0]
  def up
    # 1) Add polymorphic columns
    add_column :comments, :commentable_type, :string
    add_column :comments, :commentable_id, :bigint
    add_index :comments, [:commentable_type, :commentable_id]

    # 2) Backfill from existing recommand_item_id (if it exists)
    backfilled = false
    if column_exists?(:comments, :recommand_item_id)
      execute <<~SQL.squish
        UPDATE comments
        SET commentable_type = 'RecommandItem',
            commentable_id   = recommand_item_id
        WHERE recommand_item_id IS NOT NULL
      SQL
      backfilled = true
    end

    # 3) Enforce NOT NULL if safe (after backfill or table empty)
    comments_count = select_value("SELECT COUNT(*) FROM comments").to_i
    if backfilled || comments_count == 0
      change_column_null :comments, :commentable_type, false
      change_column_null :comments, :commentable_id, false
    end

    # 4) Drop old foreign key and column
    if foreign_key_exists?(:comments, :recommand_items)
      remove_foreign_key :comments, :recommand_items
    end
    if index_exists?(:comments, :recommand_item_id)
      remove_index :comments, :recommand_item_id
    end
    if column_exists?(:comments, :recommand_item_id)
      remove_column :comments, :recommand_item_id
    end
  end

  def down
    # Recreate old column
    add_reference :comments, :recommand_item, null: true, foreign_key: true

    # Backfill back from polymorphic to recommand_item_id where applicable
    execute <<~SQL.squish
      UPDATE comments
      SET recommand_item_id = commentable_id
      WHERE commentable_type = 'RecommandItem'
    SQL

    # Allow nulls again before dropping polymorphic columns
    change_column_null :comments, :recommand_item_id, true

    # Drop polymorphic columns and index
    if index_exists?(:comments, [:commentable_type, :commentable_id])
      remove_index :comments, column: [:commentable_type, :commentable_id]
    end
    remove_column :comments, :commentable_type if column_exists?(:comments, :commentable_type)
    remove_column :comments, :commentable_id if column_exists?(:comments, :commentable_id)
  end
end
