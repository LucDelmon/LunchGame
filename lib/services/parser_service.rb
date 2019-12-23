# frozen_string_literal: true

module LunchGame
  # class LunchGame::ParserService
  #
  # Use to parse the user input
  # at anytime the user can stop the game by putting exit
  class ParserService
    attr_reader :input

    # @param [Array<String>] allowed_inputs
    # @return [String]
    def call(allowed_inputs: nil)
      read_input
      return input unless allowed_inputs

      until allowed_inputs.include?(input)
        puts("Invalid input, possible inputs are (#{allowed_inputs.join('/')})")
        read_input
      end
      input
    end

    private

    def read_input
      @input = Readline.readline('> ', true)
      raise ::LunchGame::Errors::ExitCommandReceived if input == 'exit'
    end
  end
end

