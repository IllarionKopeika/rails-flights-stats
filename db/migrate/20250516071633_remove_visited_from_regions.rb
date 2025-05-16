class RemoveVisitedFromRegions < ActiveRecord::Migration[8.0]
  def change
    remove_column :regions, :visited, :boolean
  end
end
