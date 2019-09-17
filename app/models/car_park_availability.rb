class CarParkAvailability < ApplicationRecord
  belongs_to :car_park
  require 'net/http'
  require 'uri'

  def self.import_data()
    zone = ActiveSupport::TimeZone.new("Asia/Singapore")
    date = Time.now.in_time_zone(zone).strftime("%Y-%m-%dT%H:%m:%S")
    response = Net::HTTP.get(URI.parse("https://api.data.gov.sg/v1/transport/carpark-availability?date_time=#{date}"))
    if (response)
      response = JSON.parse(response)
      response["items"][0]["carpark_data"].each do |data|
        availabity = CarParkAvailability.where(carpark_number: data["carpark_number"]).first
        if availabity
          availabity.update(total_lots: data["carpark_info"][0]["total_lots"], lots_available: data["carpark_info"][0]["lots_available"], lot_type: data["carpark_info"][0]["lot_type"], update_datetime: data["update_datetime"])
        else
          car_availability = CarParkAvailability.new(carpark_number: data["carpark_number"], total_lots: data["carpark_info"][0]["total_lots"], lots_available: data["carpark_info"][0]["lots_available"], lot_type: data["carpark_info"][0]["lot_type"], update_datetime: data["update_datetime"])
          if car_park = CarPark.where(car_park_no: data["carpark_number"]).first_or_create
            car_availability.car_park_id = car_park.id
            car_availability.save
          end
        end
      end
    end
  end
end
