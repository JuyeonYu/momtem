class AddUserReferencesToContent < ActiveRecord::Migration[8.0]
  def change
    add_reference :reviews, :user, foreign_key: true, null: true
    add_reference :bamboos, :user, foreign_key: true, null: true
    add_reference :recommand_items, :user, foreign_key: true, null: true
    add_reference :comments, :user, foreign_key: true, null: true
  end
end

