# frozen_string_literal: true

require_relative 'car'
require_relative 'board'

class Race
  PRIZE_POOL_DECREMENT = 20

  def initialize(cars_count: 4, prize: 100, distance: 1_000)
    @cars = (1..cars_count).map { |index| Car.new(index) }
    @prize = prize
    @race_distance = distance
    @mutex = Mutex.new
    @board = Board.new(cars: @cars, distance: distance)
  end

  def start
    threads = @cars.map do |car|
      Thread.new do
        car.go_for(@race_distance)
        @mutex.synchronize { claim_prize(car) }
      end
    end
    @board.start
    threads.each(&:join)
    @board.stop
  end

  def claim_prize(car)
    text = "Car ##{car.number} Won #{@prize}$"
    @board.add_info(text)
    @prize -= PRIZE_POOL_DECREMENT
  end
end
