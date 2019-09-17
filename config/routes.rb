Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, :defaults => {:format => 'json'} do
    namespace :v1 do
      get 'car_park/nearest', :to => 'car_park#nearest_car_park'
    end
  end
end
