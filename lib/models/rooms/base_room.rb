module LunchGame
  module Rooms
    # class LunchGame::Rooms::BaseRoom
    #
    # Defines the base of a room giving inherited class methods for
    # linking themself to other rooms, navigate in four directions: north, east, south or west
    # and define option/event that can happen within the room
    class BaseRoom
      attr_accessor :east_room, :north_room, :west_room, :south_room, :origin_direction
      attr_reader :room_options_list, :visited, :game

      # @param [LunchGame::Game] game
      def initialize(game)
        @game = game
        @east_room = nil
        @north_room = nil
        @west_room = nil
        @south_room = nil
        @visited = false
        @origin_direction = nil
        @room_options_list = initial_room_options
      end

      # Link to another instance of room
      # @param [Symbol] direction
      # @param [LunchGame::Rooms::BaseRoom] room
      # @return [LunchGame::Rooms::BaseRoom]
      def link_to_room(direction:, room:)
        opposite_direction = LunchGame::Helpers.opposite_direction(direction)
        instance_variable_set("@#{direction}_room", room)
        room.instance_variable_set("@#{opposite_direction}_room", self)
      end

      # @abstract
      #
      # @return [String]
      def introduction_sentence
        raise NotImplementedError
      end

      # @abstract
      #
      # @return [String]
      def other_passages_sentence
        raise NotImplementedError
      end

      # @abstract
      #
      # @return [String]
      def room_description_sentence
        raise NotImplementedError
      end

      # @abstract
      #
      # return a list of possible action for the room
      # The room must respond to every element from the list
      # @return [Array<Symbol>]
      def initial_room_options
        raise NotImplementedError
      end

      # List all the actions of a room including the directions
      # @return [Array<String>]
      def full_options_list
        (room_options_list + available_directions).map(&:to_s)
      end

      # @return [Boolean, void]]
      def visit_room
        if !visited
          puts(introduction_sentence)
          @visited = true
        else
          puts(other_passages_sentence)
        end
      end

      # @return [void]]
      def explain_room
        print(room_description_sentence)
        puts(" (#{full_options_list.join('/')})")
      end

      # @param [Symbol] option
      # @return [LunchGame::EventResult]
      def play_options(option)
        unless respond_to?(option)
          raise(
            ArgumentError,
            "#{self.class} does not respond to #{option}, this option should not be accepted by the room"
          )
        end
        send(option)
      end

      # return the possible directions according to the rooms linked
      # @return [Array<Symbol>]
      def available_directions
        if origin_direction.nil?
          puts 'it seems that you got lost along the way, best things is to stop here'
          raise ::LunchGame::Errors::ExitCommandReceived
        end
        possibles_directions = []
        possibles_directions << :east if east_room
        possibles_directions << :north if north_room
        possibles_directions << :west if west_room
        possibles_directions << :south if south_room
        LunchGame::Helpers.relative_directions(
          origin_direction: origin_direction,
          directions: possibles_directions
        )
      end

      # Room events

      # @return [LunchGame::EventResult]
      def backward
        relative_direction_move(:backward)
      end

      # @return [LunchGame::EventResult]
      def right
        relative_direction_move(:right)
      end

      # @return [LunchGame::EventResult]
      def left
        relative_direction_move(:left)
      end

      # @return [LunchGame::EventResult]
      def forward
        relative_direction_move(:forward)
      end

      private

      # Create a room_change event result using the actual position (@origin_direction)
      # and a relative direction
      # @param [Symbol] relative_direction must be one of (backward left forward right)
      # @return [LunchGame::EventResult]
      def relative_direction_move(relative_direction)
        physical_direction = LunchGame::Helpers.relative_to_physical_direction(
          origin_direction: origin_direction,
          relative_direction: relative_direction,
        )
        LunchGame::EventResult.new(type: :room_change, next_room_direction: physical_direction)
      end
    end
  end
end
