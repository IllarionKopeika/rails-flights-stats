class CreateAircrafts < ActiveRecord::Migration[8.0]
  def change
    create_table :aircrafts do |t|
      t.string :code
      t.string :name
      t.string :manufacturer

      t.timestamps
    end
  end
end
