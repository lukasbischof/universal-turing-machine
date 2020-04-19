# frozen_string_literal: true

require 'active_support/core_ext/array/access'

# Implementation of a cellar automate
class CellarAutomate

  # @param [Symbol] start
  # @param [Symbol] accepting
  # @param [Hash] configuration
  def initialize(start:, accepting:, configuration:)
    @configuration = configuration
    @current = start
    @accepting = accepting
    @stack = ['$']
  end

  # Runs the automate with the given input,
  # returns boolean if automate ended in an accepting state
  #
  # @param [String] input
  def run(input)
    chunks = input.split ''

    while (current_transition = transition(chunks.shift))
      apply_transition(current_transition)
    end

    @current == @accepting
  end

  private

  # @param [Array] transition
  def apply_transition(transition)
    puts "Transitioning to #{transition.first}"

    @current = transition.first
    @stack.push(*transition.second.reverse)
  end

  # Evaluates the next transition,
  # based on the read char input and current stack state
  #
  # @param [String] char_input
  def transition(char_input)
    stack_input = @stack.pop

    current_config = @configuration[@current]
    step = current_config.select do |config, _transition|
      config == [char_input, stack_input]
    end

    step&.values&.first
  end
end
