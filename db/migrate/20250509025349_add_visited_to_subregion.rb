class AddVisitedToSubregion < ActiveRecord::Migration[8.0]
  def change
    add_column :subregions, :visited, :boolean, default: false
  end
end
