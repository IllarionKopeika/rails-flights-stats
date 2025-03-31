class CreateFlights < ActiveRecord::Migration[8.0]
  def change
    create_table :flights do |t|
      t.string :number
      t.string :departure_date
      t.string :departure_time
      t.string :arrival_date
      t.string :arrival_time
      t.integer :duration
      t.float :distance
      t.integer :status
      t.references :airline, null: false, foreign_key: true
      t.references :aircraft, null: false, foreign_key: true
      t.references :departure_airport, null: false, foreign_key: { to_table: :airports }
      t.references :arrival_airport, null: false, foreign_key: { to_table: :airports }

      t.timestamps
    end
  end
end
