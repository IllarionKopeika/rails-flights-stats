class AddFieldsToFlight < ActiveRecord::Migration[8.0]
  def change
    add_column :flights, :actual_departure_date, :string
    add_column :flights, :actual_departure_time, :string
    add_column :flights, :departure_status, :string
    add_column :flights, :departure_timing, :string

    add_column :flights, :actual_arrival_date, :string
    add_column :flights, :actual_arrival_time, :string
    add_column :flights, :arrival_status, :string
    add_column :flights, :arrival_timing, :string
  end
end
