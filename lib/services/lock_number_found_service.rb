# frozen_string_literal: true

module LunchGame
  # class LunchGame::LockNumberFoundService
  #
  # Execute the logic when the player find one of the lock number
  class LockNumberFoundService
    attr_reader :game

    # @param [LunchGame::Game] game
    def initialize(game)
      @game = game
    end

    # @return [void]
    def call
      lock_number = game.player.increase_known_lock_number

      if lock_number >= game.lock_password_size
        puts('You found all the number of the lock, time to go back to the entrance')
      else
        puts("still #{game.lock_password_size - lock_number} number(s) to find")
      end
    end
  end
end

