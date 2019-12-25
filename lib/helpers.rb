module LunchGame
  # Helpers for mxing between physical and relative direction
  module Helpers
    module_function

    PHYSICAL_DIRECTIONS = %i[north east south west].freeze
    RELATIVE_DIRECTIONS = %i[backward left forward right].freeze

    # @param [Symbol] origin_direction must be one of PHYSICAL_DIRECTIONS
    # @return [Integer]
    def origin_index_in_physical_direction(origin_direction)
      origin_index = PHYSICAL_DIRECTIONS.index(origin_direction)
      if origin_index.nil?
        raise(
          LunchGame::Errors::ForbiddenArgumentValueError.new(
            'origin_direction',
            origin_direction,
            PHYSICAL_DIRECTIONS)
        )
      end
      origin_index
    end

    # @param [Symbol] origin_direction must be one of PHYSICAL_DIRECTIONS
    # @return [Symbol]
    def opposite_direction(origin_direction)
      origin_index = origin_index_in_physical_direction(origin_direction)

      PHYSICAL_DIRECTIONS[(origin_index + 2) % 4]
    end

    # @param [Symbol] origin_direction must be one of PHYSICAL_DIRECTIONS
    # @param [Array<Symbol>] directions each symbol must be one of PHYSICAL_DIRECTIONS
    # @return [Array<Symbol>]
    def relative_directions(origin_direction:, directions:)
      origin_index = origin_index_in_physical_direction(origin_direction)

      directions.map do |direction|
        relative_direction(direction: direction, origin_direction_index: origin_index)
      end
    end

    # @param [Object] direction must be one of PHYSICAL_DIRECTIONS
    # @param [Object] origin_direction_index  index of the origin direction in PHYSICAL_DIRECTIONS
    # @return [Symbol]
    def relative_direction(direction:, origin_direction_index:)
      direction_index = PHYSICAL_DIRECTIONS.index(direction)
      if direction_index.nil?
        raise(LunchGame::Errors::ForbiddenArgumentValueError.new(
          'direction',
          direction,
          PHYSICAL_DIRECTIONS,
        ))
      end

      distance = direction_index - origin_direction_index
      distance += 4 if distance.negative?
      RELATIVE_DIRECTIONS[distance]
    end

    # @param [Symbol] origin_direction must be one of PHYSICAL_DIRECTIONS
    # @param [Object] relative_direction must be one of RELATIVE_DIRECTIONS
    # @return [Symbol]
    def relative_to_physical_direction(origin_direction:, relative_direction:)
      origin_index = origin_index_in_physical_direction(origin_direction)
      direction_offset = RELATIVE_DIRECTIONS.index(relative_direction)
      if direction_offset.nil?
        raise(
          LunchGame::Errors::ForbiddenArgumentValueError.new(
            'relative_direction',
            relative_direction,
            RELATIVE_DIRECTIONS,
          ),
        )
      end
      PHYSICAL_DIRECTIONS[(origin_index + direction_offset) % 4]
    end
  end
end
