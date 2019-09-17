class CarPark < ActiveRecord::Migration[5.2]
  def change
    create_table :car_parks do |t|
      t.string :car_park_no
      t.text :address
      t.float :x_coord
      t.float :y_coord
      t.float :latitude
      t.float :longitude
      t.string :car_park_type
      t.string :type_of_parking_system
      t.string :short_term_parking
      t.string :free_parking
      t.string :night_parking
      t.integer :car_park_decks, default: 0
      t.float :gantry_height
      t.string :car_park_basement
      t.timestamps
    end
    add_index :car_parks, [:latitude, :longitude]
  end
end
