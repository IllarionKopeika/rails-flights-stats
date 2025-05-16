class RemoveVisitedFromSubregions < ActiveRecord::Migration[8.0]
  def change
    remove_column :subregions, :visited, :boolean
  end
end
