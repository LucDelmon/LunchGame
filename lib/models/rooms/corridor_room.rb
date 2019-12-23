# frozen_string_literal: true

require_relative 'base_room'

module LunchGame
  module Rooms
    # class LunchGame::Rooms::CorridorRoom
    #
    # Represent a basic corridor
    class CorridorRoom < BaseRoom

      # @return [String]
      def introduction_sentence
        'You enter in a long corridor'
      end

      # @return [String]
      def other_passages_sentence
        'You are back in the corridor'
      end

      # @return [String]
      def room_description_sentence
        'Nothing to do here expect continue or going back'
      end

      # @return [Array]
      def initial_room_options
        []
      end
    end
  end
end

