# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe LunchGame::GameService do
  subject(:service) { described_class.new }
  let(:parser) { instance_double("LunchGame::ParserService") }

  describe '#ask_player_name' do
    before do
      allow(service).to receive(:parser_service).and_return(parser)
      allow(parser).to receive(:call).and_return('bob')
    end
    let(:method_call) { service.send(:ask_player_name) }

    it 'send a message, ask for an input and returns it ' do
      aggregate_failures do
        expect { method_call }.to output(
          "Enter your name to start a game\n"
        ).to_stdout
        expect(parser).to have_received(:call)
        expect(method_call).to eq 'bob'
      end
    end
  end

  describe '#greet_player' do
    let(:game) { build(:game) }
    before do
      allow(service).to receive(:game).and_return(game)
    end

    let(:method_call) { service.send(:greet_player) }
    it 'greets_player' do
      expect { method_call }.to output(
        "Hello #{game.player.name}, a new game is beginning\n"
      ).to_stdout
    end
  end

  describe '#init_player_and_game' do
    let(:method_call) { service.send(:init_player_and_game, player_name) }
    let(:player_name) { 'Lucien' }
    let(:player) { instance_double(LunchGame::Player) }
    let(:game) { instance_double(LunchGame::Game) }
    let(:room_init_service) { instance_double(LunchGame::RoomInitializerService) }
    let(:room) { instance_double(LunchGame::Rooms::DepartureRoom) }
    before do
      allow(LunchGame::Player).to receive(:new).and_return(player)
      allow(LunchGame::Game).to receive(:new).and_return(game)
      allow(game).to receive(:current_room=)
      allow(LunchGame::RoomInitializerService).to receive(:new).and_return(room_init_service)
      allow(room_init_service).to receive(:call).and_return([room])
      allow(room).to receive(:origin_direction=)
    end

    it 'correctly inits the game' do
      method_call
      aggregate_failures do
        expect(LunchGame::Player).to have_received(:new).with(player_name)
        expect(LunchGame::Game).to have_received(:new).with(player: player, lock_size: 2)
        expect(LunchGame::RoomInitializerService).to have_received(:new).with(game)
        expect(room_init_service).to have_received(:call)
      end
    end

    it 'link the game to the service' do
      method_call
      expect(service.game).to be game
    end

    it 'places the first room from the initializer service as current room' do
      method_call
      expect(game).to have_received(:current_room=).with(room)
    end

    it 'inits the origin direction of the first room to :south' do
      method_call
      expect(room).to have_received(:origin_direction=).with(:south)
    end
  end


  describe '#compute_event_result_effects' do
    let(:method_call) { service.send(:compute_event_result_effects, event_result) }
    let(:event_result) { instance_double(LunchGame::EventResult) }
    let(:type) { :harmless_event }

    before do
      allow(event_result).to receive(:type).and_return(type)
    end

    context 'with an harmless_event event' do
      it 'sends a neutral message' do
        expect { method_call }.to output(
          "The action had no effect\n"
        ).to_stdout
      end
    end

    context 'with an death event' do
      let(:type) { :death }

      it 'sends a message to inform of death' do
        expect { method_call }.to output(
          "You are now dead, better exit\n"
        ).to_stdout
      end
    end

    context 'with an number_found event' do
      let(:type) { :number_found }
      let(:lock_number_service) { instance_double(LunchGame::LockNumberFoundService) }

      before do
        allow(LunchGame::LockNumberFoundService).to receive(:new).and_return(lock_number_service)
        allow(lock_number_service).to receive(:call)
      end

      it 'calls the lock_number_service' do
        method_call
        expect(lock_number_service).to have_received(:call)
      end
    end

    context 'with an game_ended event' do
      let(:type) { :game_ended }
      let(:game) { instance_double(LunchGame::Game) }

      before do
        allow(service).to receive(:game).and_return(game)
        allow(game).to receive(:end_game)
      end

      it 'ends the game' do
        method_call
        expect(game).to have_received(:end_game)
      end
    end

    context 'with an room_change event' do
      let(:type) { :room_change }
      let(:direction) { :east }
      let(:change_room_service) { instance_double(LunchGame::ChangeRoomService) }
      before do
        allow(event_result).to receive(:next_room_direction).and_return(direction)
        allow(LunchGame::ChangeRoomService).to receive(:new).and_return(change_room_service)
        allow(change_room_service).to receive(:call)
      end
      it 'calls the change room service' do
        method_call
        expect(change_room_service).to have_received(:call).with(direction: direction)
      end
    end
  end

  describe '#execute_next_event' do
    let(:method_call) { service.send(:execute_next_event, room) }
    let(:room) { instance_double(LunchGame::Rooms::NeutralRoom) }
    let(:parser_service) { instance_double(LunchGame::ParserService) }

    before do
      allow(room).to receive(:explain_room)
      allow(room).to receive(:full_options_list).and_return(:room_options_list)
      allow(room).to receive(:play_options).and_return(:event_result)
      allow(service).to receive(:parser_service).and_return(parser_service)
      allow(service).to receive(:compute_event_result_effects)
      allow(parser_service).to receive(:call).and_return(:option_choice)
      method_call
    end

    it 'explains the room' do
      expect(room).to have_received(:explain_room)
    end

    it 'asks for user input, and limit the possibility to the room options' do
      expect(parser_service).to have_received(:call).with(allowed_inputs: :room_options_list)
    end

    it 'plays the selected option' do
      expect(room).to have_received(:play_options).with(:option_choice)
    end

    it 'computes the effect of the resulting event' do
      expect(service).to have_received(:compute_event_result_effects).with(:event_result)
    end
  end

  describe '#call' do
    let(:method_call) { service.call }
    let(:game) { instance_double(::LunchGame::Game) }
    let(:room) { instance_double(::LunchGame::Rooms::NeutralRoom) }
    let(:visit_message) { 'visit message' }

    before do
      allow(service).to receive(:ask_player_name).and_return(:player_name)
      allow(service).to receive(:init_player_and_game)
      allow(service).to receive(:greet_player)
      allow(service).to receive(:game).and_return(game)
      allow(game).to receive(:current_room).and_return(room)
      allow(game).to receive(:game_ended).and_return(true)
      allow(room).to receive(:visit_room).and_return(visit_message)
    end

    it 'asks for the player name, init the game with it and great him' do
      method_call
      aggregate_failures do
        expect(service).to have_received(:ask_player_name)
        expect(service).to have_received(:init_player_and_game).with(:player_name)
        expect(service).to have_received(:greet_player)
      end
    end

    it 'outptut the visit message' do
      expect { method_call }.to output(
        "#{visit_message}\n"
      ).to_stdout
    end

    context 'with a series of event resulting in the end of the game' do
      before do
        allow(game).to receive(:game_ended).and_return(false, false, true)
        allow(service).to receive(:execute_next_event)
      end

      it 'calls execute_next_event as long as the game is not over' do
        method_call
        expect(service).to have_received(:execute_next_event).exactly(2).times.with(room)
      end
    end
  end
end
