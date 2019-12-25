# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe LunchGame::Rooms::InterestingRoom do
  subject(:room) { described_class.new(game) }
  let(:game) { build(:game) }

  describe '#initial_room_options' do
    subject { room.initial_room_options }
    it { is_expected.to eq %i[look_in_library search_secret_compartiments_in_wall look_into_the_fireplace] }
  end

  # @let method_call
  shared_examples_for(
    'a method that returns an event result, outputs an info message and deletes himself from option'
  ) do |event_type:, info_message:, method_message:|
    it 'returns an event result' do
      aggregate_failures do
        expect(method_call).to be_an(LunchGame::EventResult)
        expect(method_call.type).to eq event_type
      end
    end

    it 'outputs a message info' do
      expect { method_call }.to output(
        info_message
      ).to_stdout
    end

    it 'deletes himself from the room options' do
      method_call
      expect(room.room_options_list).not_to include(method_message)
    end
  end

  describe '#look_into_the_fireplace' do
    let(:method_call) { room.look_into_the_fireplace }
    it_behaves_like(
      'a method that returns an event result, outputs an info message and deletes himself from option',
      event_type: :harmless_event,
      info_message: "nothing in the fireplace\n",
      method_message: :look_into_the_fireplace,
    )
  end

  describe '#search_secret_compartiments_in_wall' do
    let(:method_call) { room.search_secret_compartiments_in_wall }
    context 'with the correct random value' do
      before { allow(room).to receive(:rand).and_return(1) }

      it_behaves_like(
        'a method that returns an event result, outputs an info message and deletes himself from option',
        event_type: :number_found,
        info_message: "You found one of the number in a secret compartiment\n",
        method_message: :search_secret_compartiments_in_wall,
      )
    end

    context 'with the incorrect random value' do
      before { allow(room).to receive(:rand).and_return(0) }

      it_behaves_like(
        'a method that returns an event result, outputs an info message and deletes himself from option',
        event_type: :harmless_event,
        info_message: "nothing special on the walls but you lost a lot of time\n",
        method_message: :search_secret_compartiments_in_wall,
      )
    end

  end

  describe '#look_in_library' do
    let(:method_call) { room.look_in_library }
    context 'with the correct random value' do
      before { allow(room).to receive(:rand).and_return(1) }
      it_behaves_like(
        'a method that returns an event result, outputs an info message and deletes himself from option',
        event_type: :number_found,
        info_message: "You found one of the number for the lock in a book\n",
        method_message: :look_in_library,
      )
    end

    context 'with the incorrect random value' do
      before { allow(room).to receive(:rand).and_return(0) }

      it_behaves_like(
        'a method that returns an event result, outputs an info message and deletes himself from option',
        event_type: :harmless_event,
        info_message: "nothing special in the library\n",
        method_message: :look_in_library,
      )
    end
  end
end
