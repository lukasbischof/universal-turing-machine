# frozen_string_literal: true

require 'colorize'

# Represents the endless tape used by the turning machine
class Tape
  def initialize(content = [])
    @position = 0
    @storage = padded_content(content)[0..-2]
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

  def padded_content(content)
    (content.reduce([]) { |memo, character| memo.push(character, nil) })
  end

  def replace_nil(array)
    array.map { |item| item || 'ε' }
  end

  def projected
    length = @storage.length
    translated = Array.new(length)
    middle = (length - 1) / 2

    @storage.map.with_index do |char, index|
      translated[TapeProjection.position_for_index(index) + middle] = char
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
    TapeProjection.index_for_position(@position)
  end
end
