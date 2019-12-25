# frozen_string_literal: true

require_relative 'base_room'

module LunchGame
  module Rooms
    # class LunchGame::Rooms::DepartureRoom
    #
    # Represent the origin room of the adventure
    # The final room must be places north of it
    class DepartureRoom < BaseRoom

      # @return [String]
      def introduction_sentence
        'You start your adventure at the entrance of the dungeons. In front of you, a big door'\
        " with a lock on it. It seems that the lock need #{game.lock_password_size} numbers to open"
      end

      # @return [String]
      def other_passages_sentence
        'You are back in departure room, the door is still here'
      end

      # @return [String]
      def room_description_sentence
        'The best thing to do if you don\'t have the numbers is to explore the dungeons'
      end

      # @return [Array<Symbol>]
      def initial_room_options
        [:cheat_and_go_to_boss]
      end

      # @return [LunchGame::EventResult]
      def cheat_and_go_to_boss
        LunchGame::EventResult.new(type: :room_change, next_room_direction: :north)
      end

      private

      # Create a room_change event result using the actual position (@origin_direction)
      # and a relative direction
      # The north direction is locked and required all number of the lock
      # @param [Symbol] relative_direction must be one of (backward left forward right)
      # @return [LunchGame::EventResult]
      def relative_direction_move(relative_direction)
        physical_direction = LunchGame::Helpers.relative_to_physical_direction(
          origin_direction: origin_direction,
          relative_direction: relative_direction,
        )
        if physical_direction == :north
          player_trying_to_access_boss
        else
          LunchGame::EventResult.new(type: :room_change, next_room_direction: physical_direction)
        end
      end

      # @return [LunchGame::EventResult]
      def player_trying_to_access_boss
        if game.player_can_access_boss?
          puts('You unlock the door and enter the final room')
          LunchGame::EventResult.new(type: :room_change, next_room_direction: :north)
        else
          puts('You don\'t know the password yet, choose another direction')
          LunchGame::EventResult.new(type: :harmless_event)
        end
      end
    end
  end
end

