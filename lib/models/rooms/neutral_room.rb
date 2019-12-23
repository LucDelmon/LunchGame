# frozen_string_literal: true

require_relative 'base_room'

module LunchGame
  module Rooms
    # class LunchGame::Rooms::CorridorRoom
    #
    # Represent a basic room with anything in it
    class NeutralRoom < BaseRoom

      # @return [String]
      def introduction_sentence
        'You arrive in a basic room with nothing special'
      end

      # @return [String]
      def other_passages_sentence
        'You are back in the empty room'
      end

      # @return [String]
      def room_description_sentence
        'Best to do is to go elsewhere'
      end

      # @return [Array]
      def initial_room_options
        []
      end
    end
  end
end

