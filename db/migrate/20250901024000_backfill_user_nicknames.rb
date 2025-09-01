class BackfillUserNicknames < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    say_with_time "Backfilling user nicknames" do
      User.reset_column_information
      User.where(nickname: [nil, '']).find_each do |user|
        user.send(:ensure_nickname)
        begin
          user.save!(validate: false)
        rescue ActiveRecord::RecordNotUnique
          # In extremely rare case of collision, try again once
          user.nickname = nil
          user.send(:ensure_nickname)
          user.save!(validate: false)
        end
      end
    end
  end

  def down
    # No-op
  end
end

