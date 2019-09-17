class CarPark < ApplicationRecord
  has_one :car_park_availability
  require 'net/http'
  require 'uri'
  require 'csv'
  extend Search

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  def self.load_file
    csv_text = File.read('hdb-carpark-information.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      data = Net::HTTP.get(URI.parse('https://developers.onemap.sg/commonapi/convert/3414to4326?X=' "#{row['x_coord']}" + "&Y=" + "#{row['y_coord']}"))
      data_value = eval(data)
      CarPark.create(car_park_no: row["car_park_no"], address: row["address"], x_coord: row["x_coord"], y_coord: row["y_coord"], latitude: data_value[:latitude], longitude: data_value[:longitude], car_park_type: row["car_park_type"], type_of_parking_system: row["type_of_parking_system"], short_term_parking: row["short_term_parking"], free_parking: row["free_parking"], night_parking: row["night_parking"], car_park_decks: row["car_park_decks"], gantry_height: row["gantry_height"], car_park_basement: row["car_park_basement"])
    end
  end


  def self.search(latitude,longitude)
    within(5, :units => :miles, :origin => [latitude, longitude])
  end
end
