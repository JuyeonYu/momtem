class AddItemTypeToRecommandItem < ActiveRecord::Migration[8.0]
  def change
    add_column :recommand_items, :item_type, :string
  end
end
