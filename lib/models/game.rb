# frozen_string_literal: true

module LunchGame
  # class LunchGame::Rooms::Game
  #
  # Represent a game
  class Game
    attr_reader :player, :game_ended, :lock_password_size
    attr_accessor :current_room

    # @param player [LunchGame::Player]
    # @param lock_size [Integer]
    def initialize(player:, lock_size:)
      @player = player
      @game_ended = false
      @lock_password_size = lock_size
    end

    # @return [Boolean]
    def end_game
      puts("Congratulation #{player.name}, you ended the game")
      @game_ended = true
    end

    # @return [Boolean]
    def player_can_access_boss?
      player.known_lock_number >= lock_password_size
    end
  end
end
