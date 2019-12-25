# frozen_string_literal: true

require_relative 'base_room'

module LunchGame
  module Rooms
    # class LunchGame::Rooms::FinalRoom
    #
    # Represent the final room of the adventure
    # must be places north of the departure room
    class FinalRoom < BaseRoom

      # @return [String]
      def introduction_sentence
        'You enter a big room with noot noot your arch enemy in the middle, retreat is impossible'
      end

      # @return [String]
      def other_passages_sentence
        'How did you leave and came back ?'
      end

      # @return [String]
      def room_description_sentence
        'What is your next move?'
      end

      # @return [Array<Symbol>]
      def initial_room_options
        %i[aim_for_the_head turn_around_arch wait save_the_game]
      end

      # @return [Array]
      def available_directions
        []
      end

      # @return [LunchGame::EventResult]
      def wait
        puts 'noot noot stay where he is'
        room_options_list.delete(:wait)
        LunchGame::EventResult.new(type: :harmless_event)
      end

      # @return [LunchGame::EventResult]
      def save_the_game
        puts 'you die while trying to save the game'
        @room_options_list = ['exit']
        LunchGame::EventResult.new(type: :death)
      end

      # @return [LunchGame::EventResult]
      def turn_around_arch
        puts 'you see a vulnerable point on the tail while turning around noot noot'
        room_options_list.delete(:turn_around_arch)
        room_options_list << :aim_for_the_tail
        LunchGame::EventResult.new(type: :harmless_event)
      end

      # @return [LunchGame::EventResult]
      def aim_for_the_head
        puts 'you try to aim for the head but miss and end up on the other side'
        room_options_list.delete(:aim_for_the_head)
        LunchGame::EventResult.new(type: :harmless_event)
      end

      # @return [LunchGame::EventResult]
      def aim_for_the_tail
        puts('you aim for the tail and damage noot noot,'\
        ' in the resulting confusion you manage to defeat him and wins tons of loot')
        LunchGame::EventResult.new(type: :game_ended)
      end
    end
  end
end

