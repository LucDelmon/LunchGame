# frozen_string_literal: true

module LunchGame
  module Errors
    # Base LunchGame error
    class Base < RuntimeError; end

    # the user typed 'exit' in the parser
    class ExitCommandReceived < Base; end

    # the trying to move on a nil pointer
    class MovingToNilRoomError < Base; end

    # a forbidden value was given for a specific argument
    class ForbiddenArgumentValueError < Base
      attr_reader :message

      def initialize(argument_name, value, allowed_attributes)
        @message = "argument #{argument_name}: '#{value}' must be included in  #{allowed_attributes}"
      end
    end
  end
end
