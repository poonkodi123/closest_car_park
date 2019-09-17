namespace :car_park_availability do
  desc "import_car_park_availability_data"
  task :task1 => :environment do
    CarParkAvailability.import_data
  end

end
