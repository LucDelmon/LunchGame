# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe LunchGame::ChangeRoomService do
  subject(:service) { described_class.new(game) }
  let(:game) { build(:game) }
  let(:rooms) { build_list(:neutral_room, 2, game: game)}
  let(:second_room) { rooms.last }
  before do
    game.current_room = rooms.first
    rooms.first.east_room = second_room
  end


  describe '#call' do
    let(:method_call) { service.call(direction: direction) }
    let(:direction) { :east }
    before do
      allow(second_room).to receive(:visit_room)
    end

    it 'changes the room context and visits the room' do
      method_call
      aggregate_failures do
        expect(game.current_room).to eq second_room
        expect(game.current_room.origin_direction).to eq(
          LunchGame::Helpers.opposite_direction(direction),
        )
        expect(second_room).to have_received(:visit_room)
      end
    end

    context 'when moving in a direction with no room' do
      let(:direction) { :north }
      it 'raises an error' do
        expect { method_call }.to raise_error(LunchGame::Errors::MovingToNilRoomError)
      end
    end

    context 'with an invalid direction' do
      let(:direction) { :fe }
      it 'raises an error' do
        expect { method_call }.to raise_error(LunchGame::Errors::ForbiddenArgumentValueError)
      end
    end
  end
end
