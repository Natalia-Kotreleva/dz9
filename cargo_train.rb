# frozen_string_literal: true

class CargoTrain < Train
  def add_wagon(wagon)
    wagons.push(wagon) if (wagon.is_a? CargoWagon) && @speed.zero?
  end

  def wagon_decrease(wagon)
    wagons.delete(wagon) if (wagon.is_a? CargoWagon) && @speed.zero?
  end
end
