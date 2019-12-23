# frozen_string_literal: true

module LunchGame
  # class LunchGame::Rooms::Player
  #
  # Represent a player
  class Player
    attr_reader :name, :known_lock_number

    # @param name [String]
    def initialize(name)
      @name = name
      @known_lock_number = 0
    end

    # @return [Integer]
    def increase_known_lock_number
      @known_lock_number += 1
    end
  end
end



