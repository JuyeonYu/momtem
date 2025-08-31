class BackfillPostsFromExistingRecords < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    now = Arel.sql('CURRENT_TIMESTAMP')
    execute <<~SQL.squish
      INSERT INTO posts (postable_type, postable_id, created_at, updated_at)
      SELECT 'RecommandItem', ri.id, COALESCE(ri.created_at, #{now}), COALESCE(ri.updated_at, #{now})
      FROM recommand_items ri
      WHERE NOT EXISTS (
        SELECT 1 FROM posts p WHERE p.postable_type = 'RecommandItem' AND p.postable_id = ri.id
      )
    SQL

    execute <<~SQL.squish
      INSERT INTO posts (postable_type, postable_id, created_at, updated_at)
      SELECT 'Review', r.id, COALESCE(r.created_at, #{now}), COALESCE(r.updated_at, #{now})
      FROM reviews r
      WHERE NOT EXISTS (
        SELECT 1 FROM posts p WHERE p.postable_type = 'Review' AND p.postable_id = r.id
      )
    SQL
  end

  def down
    execute <<~SQL.squish
      DELETE FROM posts WHERE postable_type IN ('RecommandItem', 'Review')
    SQL
  end
end

