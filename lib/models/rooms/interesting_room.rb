# frozen_string_literal: true

require_relative 'base_room'

module LunchGame
  module Rooms
    # class LunchGame::Rooms::FinalRoom
    #
    # Represent a room with some options in it
    # You have chance to find a number with these actions
    class InterestingRoom < BaseRoom

      # @return [String]
      def introduction_sentence
        'You enter a room with a lot of different stuff'
      end

      # @return [String]
      def other_passages_sentence
        'You are back in the rooms with a lot of different stuff, nothing new since last time'
      end

      # @return [String]
      def room_description_sentence
        'What do you want to do'
      end

      # @return [Array<Symbol>]
      def initial_room_options
        %i[look_in_library search_secret_compartiments_in_wall look_into_the_fireplace]
      end

      # Room events

      # @return [LunchGame::EventResult]
      def look_in_library
        event = begin
          if rand(0..1) == 1
            puts 'You found one of the number for the lock in a book'
            LunchGame::EventResult.new(type: :number_found)
          else
            puts 'nothing special in the library'
            LunchGame::EventResult.new(type: :harmless_event)
          end
        end
        room_options_list.delete(:look_in_library)
        event
      end

      # @return [LunchGame::EventResult]
      def search_secret_compartiments_in_wall
        event = begin
          if rand(0..2) == 1
            puts 'You found one of the number in a secret compartiment'
            LunchGame::EventResult.new(type: :number_found)
          else
            puts 'nothing special on the walls but you lost a lot of time'
            LunchGame::EventResult.new(type: :harmless_event)
          end
        end
        room_options_list.delete(:search_secret_compartiments_in_wall)
        event
      end

      # @return [LunchGame::EventResult]
      def look_into_the_fireplace
        puts 'nothing in the fireplace'
        room_options_list.delete(:look_into_the_fireplace)
        LunchGame::EventResult.new(type: :harmless_event)
      end
    end
  end
end

