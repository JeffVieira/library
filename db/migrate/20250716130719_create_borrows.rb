class CreateBorrows < ActiveRecord::Migration[8.0]
  def change
    create_table :borrows do |t|
      t.belongs_to :user
      t.belongs_to :book
      t.boolean :returned, default: false
      t.datetime :borrow_date

      t.timestamps
    end
  end
end
