namespace :car_park_data do
  desc "import_car_park_data"
  task :task1 => :environment do
    CarPark.load_file
  end

end
