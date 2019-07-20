# frozen_string_literal: true

load 'menu.rb'

CHOICE = {
  1 => :create_station, 2 => :create_train, 3 => :create_route,
  4 => :add_station, 5 => :delete_station, 6 => :set_route,
  7 => :add_wagon, 8 => :delete_wagon, 9 => :move_train,
  10 => :show_train, 12 => :test
}.freeze

choice ||= 0

while choice != 11
  puts "
    - Создать станцию 1
    - Создать поезд 2
    - Создать маршрут 3
    - Добавить станцию к маршруту 4
    - Удалить станцию из маршрута 5
    - Назначить маршрут поезду 6
    - Добавить вагон 7
    - Отцепить вагон 8
    - Переместить поезд по маршруту 9
    - Вывести список станций и список поездов на станции 10
    - Выход 11"

  choice = gets.to_i
  send(CHOICE[choice]) if choice != 11
  attempt = 0
end
