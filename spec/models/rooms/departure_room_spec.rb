# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe LunchGame::Rooms::DepartureRoom do
  subject(:room) { described_class.new(game) }
  let(:game) { build(:game) }

  describe '#initial_room_options' do
    subject { room.initial_room_options }
    it { is_expected.to eq [:cheat_and_go_to_boss] }
  end

  describe '#cheat_and_go_to_boss' do
    let(:method_call) { room.cheat_and_go_to_boss }
    it 'returns an event result for changing room and go north' do
      aggregate_failures do
        expect(method_call).to be_an(LunchGame::EventResult)
        expect(method_call.type).to eq :room_change
        expect(method_call.next_room_direction).to eq :north
      end
    end
  end

  describe '#relative_direction_move' do
    let(:method_call) { room.send(:relative_direction_move, relative_direction) }
    let(:relative_direction) { :left }
    let(:origin_direction) { :north }
    let(:physical_direction) { :east }

    shared_examples_for 'a method that creates an EventResult with the correct physical direction' do
      it 'create an EventResult with the correct physical direction' do
        aggregate_failures do
          expect(method_call).to be_an(LunchGame::EventResult)
          expect(method_call.type).to eq :room_change
          expect(method_call.next_room_direction).to eq(physical_direction)
          expect(::LunchGame::Helpers).to have_received(:relative_to_physical_direction)
            .with(
              origin_direction: origin_direction,
              relative_direction: relative_direction,
            )
        end
      end
    end

    before do
      allow(::LunchGame::Helpers).to receive(:relative_to_physical_direction)
        .and_return(physical_direction)
      room.origin_direction = origin_direction
    end
    context 'when the resulting physical direction is not north' do
      it_behaves_like 'a method that creates an EventResult with the correct physical direction'
    end

    context 'when the resulting physical direction is north' do
      let(:physical_direction) { :north }
      context 'when the player does not have enough lock number' do
        it 'does not allow the player to move' do
          aggregate_failures do
            expect { method_call }.to output(
              "You don\'t know the password yet, choose another direction\n"
            ).to_stdout
            expect(method_call).to be_an(LunchGame::EventResult)
            expect(method_call.type).to eq :harmless_event
          end
        end
      end

      context 'when the player does have enough lock number' do
        before do
          allow(game.player).to receive(:known_lock_number).and_return(room.game.lock_password_size)
        end

        it 'output an informative message' do
          expect { method_call }.to output(
            "You unlock the door and enter the final room\n"
          ).to_stdout
        end
        it_behaves_like 'a method that creates an EventResult with the correct physical direction'
      end
    end
  end
end
