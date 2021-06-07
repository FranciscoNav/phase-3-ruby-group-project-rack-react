class CreateExpense < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :name
      t.integer :price
      t.integer :trip_id
    end
  end
end
