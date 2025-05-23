class CreateFlightStats < ActiveRecord::Migration[8.0]
  def change
    create_table :flight_stats do |t|
      t.references :user, null: false, foreign_key: true
      t.references :flightstatable, polymorphic: true, null: false
      t.integer :count, default: 0, null: false

      t.timestamps
    end
  end
end
