class AddRecommandItemToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :recommand_item, null: false, foreign_key: true
  end
end
