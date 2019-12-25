# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe LunchGame::ParserService do
  subject(:service) { described_class.new }


  describe '#call' do
    let(:service_call) { service.call }
    let(:user_input) { 'foo' }

    before do
      allow(Readline).to receive(:readline).and_return(user_input)
    end

    it 'returns the user input' do
      expect(service_call).to eq user_input
    end

    context 'when user enter exit' do
      let(:user_input) { 'exit' }
      it 'raises an ExitCommandReceived exception' do
        expect { service_call }.to raise_error( ::LunchGame::Errors::ExitCommandReceived )
      end
    end

    context 'when providing a list of allowed input' do
      let(:service_call) { service.call(allowed_inputs: allowed_inputs) }
      let(:allowed_inputs) { %w[command_1 command_2] }

      context 'with a correct user input' do
        let(:user_input) { 'command_1' }

        it 'returns the user input' do
          expect(service_call).to eq user_input
        end
      end

      context 'with invalid user input then a correct user input' do
        let(:user_input) { 'command_1' }

        before do
          allow(Readline).to receive(:readline).and_return('bad_input', user_input)
        end

        it 'outputs a message and loop' do
          expect { service_call }.to output(
            "Invalid input, possible inputs are (#{allowed_inputs.join('/')})\n"
          ).to_stdout
          expect(Readline).to have_received(:readline).exactly(2).times
        end
      end
    end
  end
end
