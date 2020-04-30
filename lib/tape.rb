# frozen_string_literal: true

require 'colorize'

# Represents the endless tape used by the turning machine
class Tape
  def initialize(content = [])
    @position = 0
    @storage = (content.dup.reduce([]) { |a, b| a.push(b, nil) })[0..-2]
  end

  def move(direction)
    if direction == :left
      move_left
    else
      move_right
    end
  end

  def write(character)
    @storage[storage_index] = character
  end

  def read
    @storage[storage_index]
  end

  def to_s
    projected_output = replace_nil(projected)
    middle = (projected_output.length - 1) / 2

    projected_output.map.with_index do |char, index|
      if (index - middle) == @position
        char.blue.bold.underline
      else
        char
      end
    end.join('|')
  end

  private

  def replace_nil(array)
    array.map { |item| item || 'ε' }
  end

  def projected
    length = @storage.length
    translated = Array.new(length)
    middle = (length - 1) / 2

    @storage.map.with_index do |char, index|
      translated[position_for_index(index) + middle] = char
    end

    translated << nil
  end

  def move_left
    @position -= 1
  end

  def move_right
    @position += 1
  end

  def storage_index
    index_for_position(@position)
  end

  def index_for_position(position)
    # [0, -1, 1, -2, 2, ...]
    return 2 * position.abs - 1 if position.negative?

    2 * position
  end

  def position_for_index(index)
    return -(index + 1) / 2 if index.odd?

    index / 2
  end
end