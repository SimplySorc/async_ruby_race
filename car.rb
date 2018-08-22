# frozen_string_literal: true

class Car
  attr_accessor :number
  attr_reader :passed_distance, :speed

  def initialize(number)
    @speed = Random.rand(10..100)
    self.number = number
    @passed_distance = 0
  end

  def go_for(distance)
    go until passed? distance
  end

  def go
    @passed_distance += speed
    sleep(0.25)
  end

  def passed?(distance)
    passed_distance >= distance
  end
end
