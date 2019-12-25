# frozen_string_literal: true

module LunchGame
  # class LunchGame::GameService
  #
  # Run the game
  class GameService
    attr_reader :game, :parser_service

    def initialize
      @parser_service = LunchGame::ParserService.new
    end

    # @return [void]]
    def call
      player_name = ask_player_name
      init_player_and_game(player_name)
      greet_player
      puts(game.current_room.visit_room)
      execute_next_event(game.current_room) until game.game_ended
    end

    private

    # Present available options to the player
    # Ask for input, give the input to the room
    # and compute the room event result
    # @param [LunchGame::Rooms::BaseRoom] current_room
    def execute_next_event(current_room)
      current_room.explain_room
      next_move = parser_service.call(allowed_inputs: current_room.full_options_list)
      event_result = current_room.play_options(next_move)
      compute_event_result_effects(event_result)
    end

    # call the adequate service if necessary for the event_result type
    # @param [LunchGame::EventResult] event_result
    def compute_event_result_effects(event_result)
      case event_result.type
      when :room_change
        change_room_service.call(direction: event_result.next_room_direction)
      when :number_found
        lock_number_found_service.call
      when :death
        puts('You are now dead, better exit')
      when :game_ended
        game.end_game
      else
        puts('The action had no effect')
      end
    end

    # @return [String]
    def ask_player_name
      puts('Enter your name to start a game')
      parser_service.call
    end

    # @param [String] player_name
    # @return [LunchGame::Rooms::BaseRoom]
    def init_player_and_game(player_name)
      player = LunchGame::Player.new(player_name)
      @game = LunchGame::Game.new(player: player, lock_size: 2)
      room_initializer_service = LunchGame::RoomInitializerService.new(game)
      rooms = room_initializer_service.call
      rooms.first.origin_direction = :south
      game.current_room = rooms.first
    end

    # @return [void]]
    def greet_player
      puts("Hello #{game.player.name}, a new game is beginning")
    end

    # @return [LunchGame::ChangeRoomService]
    def change_room_service
      @change_room_service ||= LunchGame::ChangeRoomService.new(game)
    end

    # @return [LunchGame::LockNumberFoundService]
    def lock_number_found_service
      @lock_number_found_service ||= LunchGame::LockNumberFoundService.new(game)
    end
  end
end
