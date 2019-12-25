# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe LunchGame::Rooms::FinalRoom do
  subject(:room) { described_class.new(game) }
  let(:game) { build(:game) }

  describe '#initial_room_options' do
    subject { room.initial_room_options }
    it { is_expected.to eq %i[aim_for_the_head turn_around_arch wait save_the_game] }
  end

  describe '#available_directions' do
    subject { room.available_directions }
    before do
      room.east_room = described_class.new(game)
    end
    it { is_expected.to eq [] }
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
      expect(room.full_options_list).not_to include(method_message)
    end
  end

  describe '#wait' do
    let(:method_call) { room.wait }
    it_behaves_like(
      'a method that returns an event result, outputs an info message and deletes himself from option',
      event_type: :harmless_event,
      info_message: "noot noot stay where he is\n",
      method_message: :wait,
    )
  end
  describe '#save_the_game' do
    let(:method_call) { room.save_the_game }
    it_behaves_like(
      'a method that returns an event result, outputs an info message and deletes himself from option',
      event_type: :death,
      info_message: "you die while trying to save the game\n",
      method_message: :save_the_game,
    )
  end

  describe '#turn_around_arch' do
    let(:method_call) { room.turn_around_arch }
    it_behaves_like(
      'a method that returns an event result, outputs an info message and deletes himself from option',
      event_type: :harmless_event,
      info_message: "you see a vulnerable point on the tail while turning around noot noot\n",
      method_message: :turn_around_arch,
    )
    it 'adds a new option' do
      method_call
      expect(room.full_options_list).not_to include(:aim_for_the_tail)

    end
  end
  describe '#aim_for_the_head' do
    let(:method_call) { room.aim_for_the_head }
    it_behaves_like(
      'a method that returns an event result, outputs an info message and deletes himself from option',
      event_type: :harmless_event,
      info_message: "you try to aim for the head but miss and end up on the other side\n",
      method_message: :aim_for_the_head,
    )
  end
  describe '#aim_for_the_tail' do
    let(:method_call) { room.aim_for_the_tail }
    it_behaves_like(
      'a method that returns an event result, outputs an info message and deletes himself from option',
      event_type: :game_ended,
      info_message: 'you aim for the tail and damage noot noot,'\
        " in the resulting confusion you manage to defeat him and wins tons of loot\n",
      method_message: :aim_for_the_tail,
    )
  end
end
