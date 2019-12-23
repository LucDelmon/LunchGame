# frozen_string_literal: true

require_relative 'base_room'

module LunchGame
  module Rooms
    # class LunchGame::Rooms::CorridorRoom
    #
    # Represent a deadly room
    # Arriving in one of those rooms mean that you are dead
    class DeadlyRoom < BaseRoom

      # @return [String]
      def introduction_sentence
        [
          'As you enter in the room a deadly dart trap kills you',
          'You fall into lava',
          'You find a good looking red potion and drink it, it\'s poison',
          'The door close itself behind you and a deadly gas is released into the room',
          'You die'
        ].sample
      end

      # @return [String]
      def other_passages_sentence
        'Wait, what?'
      end

      # @return [String]
      def room_description_sentence
        'You are dead, the only option is to exit'
      end

      # @return [Array<Symbol>]
      def full_options_list
        [:exit]
      end

      # @return [Array]
      def initial_room_options
        []
      end
    end
  end
end

