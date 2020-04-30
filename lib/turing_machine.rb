# frozen_string_literal: true

require 'active_support/core_ext/array/access'
require_relative 'tape'

# Implementation of a turing machine
class TuringMachine
  def self.transition(new_state, write_operation, movement_operation)
    [new_state, write_operation, movement_operation]
  end

  # @param [Symbol] start
  # @param [Symbol] accepting
  # @param [Hash] configuration
  def initialize(start:, accepting:, configuration:)
    @configuration = configuration
    @current_state = start
    @accepting = accepting
  end

  # @param [Tape] tape
  def run(tape)
    @tape = tape

    while (current_transition = next_transition)
      apply_transition(current_transition)
    end

    @current_state == @accepting
  end

  private

  def apply_transition(transition)
    puts 'Current Tape: '
    puts @tape
    puts "--> Applying transition #{transition}"
    puts

    new_state, write_operation, movement_operation = transition

    @current_state = new_state
    @tape.write write_operation
    @tape.move movement_operation
  end

  def next_transition
    input_character = @tape.read
    step = current_config.select do |config, _transition|
      config == input_character
    end

    step&.values&.first
  end

  def current_config
    @configuration[@current_state]
  end
end
