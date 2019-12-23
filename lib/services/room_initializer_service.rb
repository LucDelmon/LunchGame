# frozen_string_literal: true

module LunchGame
  # class LunchGame::RoomInitializerService
  #
  # Instantiate the room and linked them
  class RoomInitializerService
    attr_reader :rooms, :game

    # @param [LunchGame::Game] game
    def initialize(game)
      @game = game
      @rooms = []
    end

    def call
      init_rooms
      link_rooms
      rooms
    end

    private

    # @return [Array<LunchGame::Rooms::BaseRoom>]
    def init_rooms
      rooms << LunchGame::Rooms::DepartureRoom.new(game) # 0
      rooms << LunchGame::Rooms::NeutralRoom.new(game) # 1
      rooms << LunchGame::Rooms::NeutralRoom.new(game) # 2
      rooms << LunchGame::Rooms::NeutralRoom.new(game) # 3
      rooms << LunchGame::Rooms::NeutralRoom.new(game) # 4
      rooms << LunchGame::Rooms::DeadlyRoom.new(game) # 5
      rooms << LunchGame::Rooms::DeadlyRoom.new(game) # 6
      rooms << LunchGame::Rooms::DeadlyRoom.new(game) # 7
      rooms << LunchGame::Rooms::InterestingRoom.new(game) # 8
      rooms << LunchGame::Rooms::InterestingRoom.new(game) # 9
      rooms << LunchGame::Rooms::InterestingRoom.new(game) # 10
      rooms << LunchGame::Rooms::CorridorRoom.new(game) # 11
      rooms << LunchGame::Rooms::FinalRoom.new(game) # 12
    end

    # @return [LunchGame::Rooms::BaseRoom>]
    def link_rooms
      link_room(0, :north, 12)
      link_room(0, :east, 1)
      link_room(1, :east, 6)
      link_room(1, :south, 4)
      link_room(1, :north, 9)
      link_room(9, :east, 5)
      link_room(9, :north, 2)
      link_room(9, :west, 10)
      link_room(0, :west, 11)
      link_room(11, :west, 3)
      link_room(3, :north, 8)
      link_room(3, :south, 7)
    end

    # @param [Integer] first_room index of the first room to link
    # @param [Symbol] direction direction from first room to second room
    # @param [Integer] second_room index of the second room to link
    def link_room(first_room, direction, second_room)
      rooms[first_room].link_to_room(direction: direction, room: rooms[second_room])
    end
  end
end
