class FixDuplicatePolymorphicColumnsOnComments < ActiveRecord::Migration[8.0]
  def up
    # Backfill commentable_* from legacy item_* if present
    if column_exists?(:comments, :item_type) && column_exists?(:comments, :item_id)
      execute <<~SQL
        UPDATE comments
        SET commentable_type = COALESCE(commentable_type, item_type),
            commentable_id   = COALESCE(commentable_id,   item_id)
      SQL

      remove_index :comments, column: [:item_type, :item_id] if index_exists?(:comments, [:item_type, :item_id])
      remove_column :comments, :item_type
      remove_column :comments, :item_id
    end

    # Ensure an index on valid polymorphic columns exists
    unless index_exists?(:comments, [:commentable_type, :commentable_id])
      add_index :comments, [:commentable_type, :commentable_id]
    end
  end

  def down
    # Recreate legacy columns (nullable) and backfill from commentable_*
    add_column :comments, :item_type, :string unless column_exists?(:comments, :item_type)
    add_column :comments, :item_id, :bigint unless column_exists?(:comments, :item_id)

    execute <<~SQL
      UPDATE comments
      SET item_type = commentable_type,
          item_id   = commentable_id
    SQL

    add_index :comments, [:item_type, :item_id] unless index_exists?(:comments, [:item_type, :item_id])
  end
end

