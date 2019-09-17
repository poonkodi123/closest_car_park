class Api::V1::CarParkController < ApplicationController

  def nearest_car_park
    if params[:latitude].present? && params[:longitude].present?
      params[:page] ||= 1
      params[:per_page] ||= 3
      details  = CarPark.search(params[:latitude],params[:longitude]).paginate(page: params[:page], per_page: params[:per_page]).as_json(include: :car_park_availability)
      result ||=[]
      details.each do |data|
        result << {address: data["address"], latitude: data["latitude"], longitude: data["longitude"],total_lots: data["car_park_availability"].present? ? data["car_park_availability"]["total_lots"] : nil ,lots_available: data["car_park_availability"].present? ? data["car_park_availability"]["lots_available"] : nil}
      end
      render json: result, status: 200
    else
      render json: {:message => "latitude && longitude is mandatory"}, status: 400
    end
  end
end
