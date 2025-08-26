class CreateRecommandItems < ActiveRecord::Migration[8.0]
  def change
    create_table :recommand_items do |t|
      t.string :title
      t.text :body
      t.text :link

      t.timestamps
    end
  end
end
