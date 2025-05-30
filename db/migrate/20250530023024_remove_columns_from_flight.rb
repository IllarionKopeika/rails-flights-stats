class RemoveColumnsFromFlight < ActiveRecord::Migration[8.0]
  def change
    remove_column :flights, :actual_departure_date, :string
    remove_column :flights, :actual_departure_time, :string
    remove_column :flights, :departure_status, :string
    remove_column :flights, :departure_timing, :string
    remove_column :flights, :actual_arrival_date, :string
    remove_column :flights, :actual_arrival_time, :string
    remove_column :flights, :arrival_status, :string
    remove_column :flights, :arrival_timing, :string
  end
end
