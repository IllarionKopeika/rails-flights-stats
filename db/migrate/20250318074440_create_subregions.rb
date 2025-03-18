class CreateSubregions < ActiveRecord::Migration[8.0]
  def change
    create_table :subregions do |t|
      t.jsonb :name, null: false, default: {}
      t.references :region, null: false, foreign_key: true

      t.timestamps
    end

    add_index :subregions, :name, using: :gin
  end
end
