class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.references :user, foreign_key: true, index: true
      t.string :name
      t.string :color, length: 6, null: true
      t.timestamps
    end
  end
end
