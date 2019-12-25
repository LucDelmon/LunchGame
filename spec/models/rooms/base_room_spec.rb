# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe LunchGame::Rooms::BaseRoom do
  subject(:base_room) { described_class.new(game) }
  let(:game) { build(:game) }


  describe '.new' do
    it 'raise a not implemented error' do
      expect { base_room }.to raise_error(NotImplementedError)
    end
  end

  context 'when extended by a class that implements :initial_room_options' do
    let(:initial_room_options_list) { [:option_1] }
    let(:extending_class) do
      Class.new(described_class) do
        def initial_room_options
          [:option_1]
        end
      end
    end
    subject(:room) { extending_class.new(game) }

    describe '.new' do
      it 'init the room using the initial_room_options' do
        aggregate_failures do
          expect(room.game).to eq game
          expect(room.east_room).to eq nil
          expect(room.north_room).to eq nil
          expect(room.west_room).to eq nil
          expect(room.south_room).to eq nil
          expect(room.visited).to eq false
          expect(room.origin_direction).to eq nil
          expect(room.room_options_list).to eq initial_room_options_list
        end
      end
    end

    describe '#link_to_room' do
      let(:direction) { :east }
      let(:other_room) { extending_class.new(game) }

      let(:method_call) { room.link_to_room(direction: direction, room: other_room) }

      it 'links the rooms together ' do
        method_call
        aggregate_failures do
          expect(room.east_room).to eq other_room
          expect(other_room.west_room).to eq room
        end
      end
    end

    describe '#available_directions' do
      let(:method_call) { room.available_directions }

      context 'without origin_direction' do
        it 'raises an error' do
          expect { method_call }.to raise_error(::LunchGame::Errors::ExitCommandReceived)
        end
      end

      context 'with an origin direction and some linked room' do
        let(:origin_direction) { :south }
        let(:expected_result) { :my_result }
        before do
          room.origin_direction = origin_direction
          room.east_room = extending_class.new(game)
          room.south_room = extending_class.new(game)
          allow(LunchGame::Helpers).to receive(:relative_directions).and_return(expected_result)
        end

        it 'returns the relative available direction' do
          expect(method_call).to eq(expected_result)
          expect(LunchGame::Helpers).to have_received(:relative_directions)
            .with(
              origin_direction: origin_direction,
              directions: %i[east south],
            )
        end
      end
    end

    describe '#full_options_list' do
      let(:method_call) { room.full_options_list }
      let(:available_directions) { %i[forward backward] }
      before do
        allow(room).to receive(:available_directions).and_return(available_directions)
      end
      
      it 'returns available directions and room options as a list of string' do
        expect(method_call).to contain_exactly(
          *(available_directions + initial_room_options_list).map(&:to_s)
        )
      end

      context 'when the room_options_list change' do
        let(:new_option) { :option_2 }
        before do
          room.room_options_list << new_option
        end

        it 'returns the new options' do
          expect(method_call).to include(new_option.to_s)
        end
      end
    end

    describe '#visit_room' do
      let(:method_call) { room.visit_room }
      let(:introduction_sentence) { 'intro' }
      let(:other_passages_sentence) { 'other' }

      before do
        allow(room).to receive(:introduction_sentence).and_return(introduction_sentence)
        allow(room).to receive(:other_passages_sentence).and_return(other_passages_sentence)
      end

      it 'output introduction sentence and mark the room as visited' do
        aggregate_failures do
          expect { method_call }.to output(introduction_sentence + "\n").to_stdout
          expect(room.visited).to eq true
        end
      end

      context 'when the room have already been visited' do
        before do
          room.visit_room
        end

        it 'output the other_passages_sentence' do
          expect { method_call }.to output(other_passages_sentence + "\n").to_stdout
        end
      end
    end

    describe '#explain_room' do
      let(:method_call) { room.explain_room }
      let(:room_description_sentence) { 'room cool' }
      let(:options_list) { %i[forward option_4] }

      before do
        allow(room).to receive(:room_description_sentence).and_return(room_description_sentence)
        allow(room).to receive(:full_options_list).and_return(options_list)
      end

      it 'output room_description_sentence and the available options' do
        expect { method_call }.to output(
          room_description_sentence + " (#{options_list.join('/')})" + "\n"
        ).to_stdout
      end
    end

    describe '#play_options' do
      let(:method_call) { room.play_options(option) }
      let(:option) { :my_option }

      context 'when the instance does not implement the provided option' do
        it 'raises an ArgumentError' do
          expect { method_call }.to raise_error(ArgumentError)
        end
      end

      context 'when the instance does implement the provided option' do
        before do
          allow(room).to receive(option)
        end
        it 'calls the method' do
          method_call
          expect(room).to have_received(option)
        end
      end
    end

    describe '#relative_direction_move' do
      let(:method_call) { room.send(:relative_direction_move, relative_direction) }
      let(:relative_direction) { :left }
      let(:origin_direction) { :north }
      let(:physical_direction) { :east }

      before do
        allow(::LunchGame::Helpers).to receive(:relative_to_physical_direction)
          .and_return(physical_direction)
        room.origin_direction = origin_direction
      end

      it 'creates an EventResult with the correct physical direction' do
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
  end
end
