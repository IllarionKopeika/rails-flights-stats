class RemoveVisitedFromCountries < ActiveRecord::Migration[8.0]
  def change
    remove_column :countries, :visited, :boolean
  end
end
