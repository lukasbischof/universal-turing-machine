# frozen_string_literal: true

require 'active_support/core_ext/array/access'

# Implementation of a turing maching
class TuringMachine
  def initialize(start:, accepting:, configuration:)
    @configuration = configuration
    @current = start
    @accepting = accepting
    @stack = ['$']
  end

  def run(input)
    chunks = input.split ''

    while (current_transition = transition(chunks.shift))
      apply_transition(current_transition)
    end

    @current == @accepting
  end

  private

  def apply_transition(transition)
    puts "Transitioning to #{transition.first}"

    @current = transition.first
    @stack.push(*transition.second.reverse)
  end

  def transition(char_input)
    stack_input = @stack.pop

    current_config = @configuration[@current]
    step = current_config.select do |config, _transition|
      config == [char_input, stack_input]
    end

    step&.values&.first
  end
end
