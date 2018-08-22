# frozen_string_literal: true

class Board
  TRACK_LENGTH = 100
  TRACK_OVERLAP = 20

  attr_reader :race_distance, :info

  def initialize(cars: [], distance: 1_000)
    @cars = cars
    @race_distance = distance
    @mutex = Mutex.new
    @info = []
    @is_active = false
    @mutex = Mutex.new
  end

  def start
    @is_active = true
    Thread.new do
      while @is_active
        print_board
        sleep(0.1)
      end
    end
  end

  def stop
    @is_active = false
  end

  def add_info(text)
    @info.push(text)
    print_board
  end

  private

  def car_position(car)
    ((car.passed_distance.to_f / race_distance) * 100).to_i
  end

  def car_representation(car)
    "\b\b[#{car.number}]"
  end

  def legend
    { road: '=', x_ident: '|'}
  end

  def print_board
    @mutex.synchronize do
      track = print_track
      puts `clear`
      (0...(@cars.size)).each do |i|
        row = [*track[i], legend[:x_ident], info[i]]
        puts row.join
      end
    end
  end

  def print_track
    @cars.map { |car| print_car(car) }
  end

  def print_car(car)
    car_at_position = car_position(car)
    (0..TRACK_LENGTH).map do |position|
      position == car_at_position ? car_representation(car) : legend[:road]
    end
  end

  def print_car_info(car)
    car_currently_at = car_position(car)
    (0..TRACK_LENGTH).map do |position|
      case position
      when TRACK_LENGTH
        legend[:road]
      when car_currently_at
        car_representation(car)
      else
        legend[:road]
      end
    end
  end
end

#--------------------------------------------------------------------------------------------------|-------------------|
#==============================================[1]=================================================|                   |
#===================================================================[2]============================|                   |
#=====================[3]==========================================================================|                   |
#==========================================================[4]=====================================| Car 1 Won 10$     |
#--------------------------------------------------------------------------------------------------|-------------------|
