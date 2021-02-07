class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.belongs_to :book, null: true, foreign_key: true, index: true
      t.string :title, null: false
      t.text :content
      t.belongs_to :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
