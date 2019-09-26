class Api::V1::CarParkController < ApplicationController

  def nearest_car_park
    if params[:latitude].present? && params[:longitude].present?
      params[:page] ||= 1
      params[:per_page] ||= 3
      puts Benchmark.measure {
      details = CarPark.search(params[:latitude], params[:longitude],params[:page],params[:per_page])
      render json: details, status: 200
      }
    else
      render json: {:message => "latitude && longitude is mandatory"}, status: 400
    end
  end
end
