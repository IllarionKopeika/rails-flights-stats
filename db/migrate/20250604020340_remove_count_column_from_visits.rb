class RemoveCountColumnFromVisits < ActiveRecord::Migration[8.0]
  def change
    remove_column :visits, :count, :integer
  end
end
