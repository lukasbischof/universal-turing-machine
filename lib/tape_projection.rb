# frozen_string_literal: true

# Projects an endless two dimensional tape
# on an endless one dimensional structure
# returning the structure of:
# [0, -1, 1, -2, 2, ...]
module TapeProjection
  def self.index_for_position(position)
    return 2 * position.abs - 1 if position.negative?

    2 * position
  end

  def self.position_for_index(index)
    return -(index + 1) / 2 if index.odd?

    index / 2
  end
end
