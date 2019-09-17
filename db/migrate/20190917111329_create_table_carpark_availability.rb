class CreateTableCarparkAvailability < ActiveRecord::Migration[5.2]
  def change
    create_table :car_park_availabilities do |t|
      t.integer :total_lots, default: 0
      t.integer :lots_available, default: 0
      t.string  :lot_type
      t.string  :carpark_number
      t.integer :car_park_id
      t.datetime :update_datetime
      t.timestamps
    end
    add_index :car_park_availabilities, [:total_lots, :lots_available]
  end
end
