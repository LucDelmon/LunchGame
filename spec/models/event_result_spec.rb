# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe LunchGame::EventResult do
  subject(:event) { described_class.new(**attrs) }
  let(:type) { :game_ended }
  let(:next_room_direction) { nil }

  let(:attrs) do
    {
      type: type,
      next_room_direction: next_room_direction
    }
  end


  describe '.new' do
    context 'with a valid type' do
      it 'initializes the event' do
        expect(event.type).to eq type
      end
    end

    context 'with a invalid type' do
      let(:type) { :foo }

      it 'raises an argument error' do
        expect { event }.to raise_error(ArgumentError)
      end
    end

    context 'with a room_change type' do
      let(:type) { :room_change }
      it 'raises an argument error for the missing next_room_direction' do
        expect { event }.to raise_error(
          ArgumentError, 
          'Missing argument next_room_direction when initialising EventResult of type :room_change',
        )
      end

      context 'when providing a next_room_direction' do
        let(:next_room_direction) { :east }

        it 'initializes the event with the attributes' do
          expect(event.type).to eq type
          expect(event.next_room_direction).to eq next_room_direction
        end
      end
    end
  end
end
