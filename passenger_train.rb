# frozen_string_literal: true

class PassengerTrain < Train
  def add_wagon(wagon)
    wagons.push(wagon) if (wagon.is_a? PassengerWagon) && @speed.zero?
  end

  def wagon_decrease(wagon)
    wagons.delete(wagon) if (wagon.is_a? PassengerWagon) && @speed.zero?
  end
end
