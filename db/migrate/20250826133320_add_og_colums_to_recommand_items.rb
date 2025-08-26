class AddOgColumsToRecommandItems < ActiveRecord::Migration[8.0]
  def change
    add_column :recommand_items, :og_title, :string
    add_column :recommand_items, :og_description, :text
    add_column :recommand_items, :og_image, :text
  end
end
