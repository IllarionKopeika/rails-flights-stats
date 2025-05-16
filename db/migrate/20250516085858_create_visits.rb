class CreateVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :visits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :visitable, polymorphic: true, null: false
      t.integer :count, default: 0, null: false

      t.timestamps
    end
  end
end
