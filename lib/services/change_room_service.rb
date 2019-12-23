# frozen_string_literal: true

module LunchGame
  # class LunchGame::ChangeRoomService
  #
  # Run the logic for changing the room context
  class ChangeRoomService
    attr_reader :game
    
    # @param [LunchGame::Game] game
    def initialize(game)
      @game = game
    end

    # Change the game current room and set the origin direction in the new room
    # @param [Symbol] direction must be one of LunchGame::Helpers::PHYSICAL_DIRECTIONS
    # @return [LunchGame::Rooms::BaseRoom]
    def call(direction:)
      unless LunchGame::Helpers::PHYSICAL_DIRECTIONS.include?(direction)
        raise(
          LunchGame::Errors::ForbiddenArgumentValueError.new(
            'direction',
            direction,
            LunchGame::Helpers::PHYSICAL_DIRECTIONS,
          ),
        )
      end

      next_room = game.current_room.send("#{direction}_room")
      raise LunchGame::Errors::MovingToNilRoomError unless next_room

      game.current_room = next_room
      game.current_room.origin_direction = LunchGame::Helpers.opposite_direction(direction)
      game.current_room.visit_room
      game.current_room
    end
  end
end

