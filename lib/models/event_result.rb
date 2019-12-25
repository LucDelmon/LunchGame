# frozen_string_literal: true

module LunchGame
  # class LunchGame::Rooms::EventResult
  #
  # Represent the result of an event that happened in a room
  # The game service will process it
  class EventResult
    attr_reader :type, :next_room_direction

    ALLOWED_TYPES = %i[room_change game_ended number_found harmless_event death].freeze

    # @param type: [String]
    def initialize(type:, next_room_direction: nil)
      unless ALLOWED_TYPES.include?(type)
        raise ArgumentError, "Unrecognized type: #{@type} while creating an EventResult"
      end
      if type == :room_change && next_room_direction.nil?
        raise ArgumentError, 'Missing argument next_room_direction when initialising EventResult of type :room_change'
      end
      
      @type = type
      @next_room_direction = next_room_direction
    end
  end
end
