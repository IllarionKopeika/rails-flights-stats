class CreateGeneralStats < ActiveRecord::Migration[8.0]
  def change
    create_table :general_stats do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_flights, default: 0, null: false
      t.integer :international_flights, default: 0, null: false
      t.integer :domestic_flights, default: 0, null: false
      t.integer :total_duration, default: 0, null: false
      t.float :total_distance, default: 0, null: false

      t.timestamps
    end
  end
end
