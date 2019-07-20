# frozen_string_literal: true

load 'train.rb'
load 'passenger_train.rb'
load 'cargo_train.rb'
load 'passenger_wagon.rb'
load 'cargo_wagon.rb'
load 'station.rb'
load 'route.rb'

@created_trains = []
@created_stations = []
@created_routes = []

def test
  novo = Station.new('novo')
  soko = Station.new('soko')

  line1 = Route.new(novo, soko, 'line1')

  qwe1 = PassengerTrain.new('qwe1', '123-12')
  qwe2 = CargoTrain.new('qwe2', '123-13')

  qwe1.set_route(line1)
  qwe2.set_route(line1)

  wag1 = PassengerWagon.new
  qwe1.add_wagon(wag1)

  wag2 = CargoWagon.new
  qwe2.add_wagon(wag2)

  novo.each_train do |train|
    puts "Number: #{train.number}, Type: #{train.class.name}, Wagons: #{train.wagons.size}"
  end
  qwe1.each_wagon do |wagon|
    puts "Number: #{wagon.number}, Type: #{wagon.class.name}, Seat: #{wagon.seat}"
  end
  qwe2.each_wagon do |wagon|
    puts "Number: #{wagon.number}, Type: #{wagon.class.name}, Volume: #{wagon.volume}"
  end
end

def print_function(array, name)
  array.each do |element|
    print "#{element.send(:"#{name}")}: #{array.index(element) + 1}\n"
  end
end

def create_station
  puts 'Введите название станции'
  name_station = gets.chomp
  name_station = Station.new(name_station.to_s)
  @created_stations.push(name_station)
  puts 'Создано.'
end

def set_route
  puts 'Выберите номер поезда для назначения маршрута'
  print_function(@created_trains, 'name_train')
  train_number = gets.to_i
  puts 'Выберите номер маршрута'
  print_function(@created_routes, 'route_name')
  route_number = gets.to_i
  @created_trains[train_number - 1].set_route(@created_routes[route_number - 1])
  puts 'Назначено.'
end

def create_train
  puts 'Выберите тип поезда: пассажирский (1), грузовой (2)'
  train_type = gets.to_i
  begin
    puts 'Введите имя поезда'
    train = gets.chomp
    puts 'Введите номер поезда'
    train_number = gets.chomp

    train = PassengerTrain.new(train.to_s, train_number.to_s) if train_type == 1
    train = CargoTrain.new(train.to_s, train_number.to_s) if train_type == 2
  rescue StandardError => e
    puts e.message
    retry
  end
  @created_trains.push(train)
  puts "Создан #{train}"
end

def create_route
  if @created_stations.size < 2
    puts 'Не создано достаточно станций'
  else
    puts 'Введите название маршрута'
    name_route = gets.chomp
    puts 'Выберите номер начальной станции из созданных'
    print_function(@created_stations, 'name_station')
    first_station = gets.to_i
    puts "Выберите номер конечной станции, кроме #{first_station}"
    print_function(@created_stations, 'name_station')
    final_station = gets.to_i
  end
  name_route = Route.new(@created_stations[first_station - 1], @created_stations[final_station - 1], name_route.to_s)
  @created_routes.push(name_route)
  puts "Маршрут #{name_route.route_name} создан."
end

def add_station
  puts 'Выберите номер маршрута для добавления станции'
  print_function(@created_routes, 'route_name')
  route_number = gets.to_i
  puts 'Какой номер станции добавить?'
  print_function(@created_stations, 'name_station')
  station_number = gets.to_i
  if @created_routes[route_number - 1].stations.include?(@created_stations[station_number - 1]) == true
    puts 'Станция уже добавлена'
  else
    @created_routes[route_number - 1].station_add(@created_stations[station_number - 1])
    puts 'Добавлено'
  end
end

def delete_station
  puts 'Выберите номер маршрута для удаления станции'
  print_function(@created_routes, 'route_name')
  route_number = gets.to_i
  puts 'Какой номер станции удалить?'
  print_function(@created_stations, 'name_station')
  station_number = gets.to_i
  if @created_stations[station_number - 1] != @created_routes[route_number - 1].stations.first && @created_stations[station_number - 1] != @created_routes[route_number - 1].stations.last
    @created_routes[route_number - 1].station_delete(@created_stations[station_number - 1])
    puts 'Станция удалена'
  else
    puts 'Выберите станцию, которая не является начальной/конечной.'
  end
end

def delete_wagon
  puts 'Введите номер поезда, у которого хотите удалить вагон'
  print_function(@created_trains, 'name_train')
  train_number = gets.to_i
  puts "Введите номер вагона #{@created_trains[train_number - 1].wagons}"
  wagon_number = gets.to_i
  @created_trains[train_number - 1].wagon_decrease(@created_trains[train_number - 1].wagons[wagon_number - 1])
  puts 'Удалено.'
end

def show_train
  @created_stations.each do |st|
    puts "Станция: #{st.name_station} поезда на станции: "
    st.trains.each do |tr|
      puts tr.name_train.to_s
    end
  end
end

def move_train
  puts 'Какой поезд перемещать'
  print_function(@created_trains, 'name_train')
  train_number = gets.to_i
  if @created_trains[train_number - 1].route.nil?
    puts 'Поезду не назначен маршрут'
  else puts 'Вперед (1) или назад (2)?'
       choice = gets.to_i
       @created_trains[train_number - 1].station_next if choice == 1
       @created_trains[train_number - 1].station_prev if choice == 2
       puts "Поезд перемещен на станцию #{@created_trains[train_number - 1].station.name_station}"
  end
end

def add_wagon
  puts 'Введите имя вагона'
  wagon_name = gets.chomp
  puts 'Введите номер поезда, к которому хотите добавить'
  print_function(@created_trains, 'name_train')
  train_number = gets.to_i
  wagon_name = CargoWagon.new if @created_trains[train_number - 1].is_a? CargoTrain
  wagon_name = PassengerWagon.new if @created_trains[train_number - 1].is_a? PassengerTrain
  @created_trains[train_number - 1].add_wagon(wagon_name)
  puts 'Добавлено.'
end
