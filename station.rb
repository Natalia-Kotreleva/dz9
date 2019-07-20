# frozen_string_literal: true

load 'instance_counter.rb'
load 'accessor.rb'
load 'validation.rb'

class Station
  include InstanceCounter
  include Accessors
  include Validation

  @@stations = []

  attr_accessor :trains, :name_station

  def initialize(name_station)
    @name_station = name_station
    @trains = []
    validate!
    register_instance
    @@stations << self
  end

  def remove_train(train)
    @trains.delete(train)
  end

  def train_arrives(train)
    @trains.push(train)
  end

  def trains_type
    cargo_trains = @trains.count { |train| train.type == :cargo }
    passenger_trains = @trains.count { |train| train.type == :passenger }
    "cargo: #{cargo_trains}, passenger: #{passenger_trains}"
  end

  def self.all
    @@stations
  end

  def each_train
    @trains.each do |train|
      yield train if block_given?
    end
  end

  def valid?
    validate!
    true
  rescue false
  end

  protected

  def validate!
    raise 'Name is nil' if name_station.nil?
    raise 'Length < 3' if name_station.length < 3
  end
end
