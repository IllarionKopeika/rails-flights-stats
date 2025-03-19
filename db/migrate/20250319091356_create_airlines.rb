class CreateAirlines < ActiveRecord::Migration[8.0]
  def change
    create_table :airlines do |t|
      t.string :code
      t.string :name
      t.string :logo_url

      t.timestamps
    end
  end
end
