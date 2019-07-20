# frozen_string_literal: true

load 'name_company.rb'
load 'instance_counter.rb'

class Train
  include NameCompany
  include InstanceCounter

  attr_reader :route, :speed, :wagon, :name_train, :station, :number
  attr_accessor :wagons

  @@trains = []

  def initialize(name_train, number)
    @name_train = name_train
    @speed = 0
    @wagons = []
    @name_company = 'company'
    @number = number
    validate!
    register_instance
    @@trains << self
  end

  TRAIN_NUMBER_FORMAT = /^[a-z0-9]{3}-*[a-z0-9]{2}$/i.freeze

  def speed_increase(value)
    @speed += value if value.positive?
  end

  def speed_decrease(value)
    @speed -= value
    @speed = 0 if @speed.negative?
  end

  def set_route(route)
    @route = route
    @station = route.stations[0]
    route.stations[0].train_arrives(self)
  end

  def station_next
    @station = @route.stations[@route.stations.index(@station) + 1] if @station != @route.stations.last
  end

  def station_prev
    @station = @route.stations[@route.stations.index(@station) - 1] if @route.stations.index(@station) != 0
  end

  def station_return
    "#{@route.stations[@route.stations.index(@station) - 1].name_station},
#{@station.name_station},
#{@route.stations[@route.stations.index(@station) + 1].name_station}"
  end

  def each_wagon
    @wagons.each do |wagon|
      yield wagon if block_given?
    end
  end

  def self.find(number)
    @@trains.each do |train|
      return train if train.number == number
    end
  end

  def valid?
    validate!
    true
  rescue false
  end

  protected

  def validate!
    raise 'Length train name < 3' if name_train.length < 3
    raise 'Invalid format train number' if number !~ TRAIN_NUMBER_FORMAT
  end
end
