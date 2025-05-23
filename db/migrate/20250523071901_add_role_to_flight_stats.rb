class AddRoleToFlightStats < ActiveRecord::Migration[8.0]
  def change
    add_column :flight_stats, :role, :integer, default: 0, null: false
  end
end
