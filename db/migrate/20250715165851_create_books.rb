class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :isbn, null: false
      t.integer :copies_available, default: 0
      t.string :genre

      t.timestamps
    end
  end
end
