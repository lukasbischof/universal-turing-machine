#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'celler_automate'
require_relative 'upn_calculator'

# Main class of the app, runs the automate and calculates the result if it's valid
class Main
  # Configuration of the automate:
  # Structure:
  # {state: [transition_functions]}
  CONFIGURATION = {
    q0: {
      # [ input_char, stack_char ] => [ new_state, [ pushed stack chars ] ]
      %w[D $] => [:q0, %w[D $]],
      %w[D D] => [:q0, %w[D D]],
      %w[O D] => [:q1, []]
    },
    q1: {
      %w[O D] => [:q1, []],
      %w[D D] => [:q0, %w[D D]],
      # nil = epsilon
      [nil, 'D'] => [:q2, []]
    },
    q2: {
      [nil, '$'] => [:q3, []]
    },
    q3: {}
  }.freeze

  # Runs main app
  def run
    puts 'Geben Sie Ihr Wort ein: '

    # Read user input from command line and reject whitespaces
    word = gets.chomp.gsub(/\s/, '')

    # Replace all digits with 'D' and operators with 'O'
    prepared_input = prepare_input(word)
    valid = automate.run(prepared_input)

    puts(valid ? '--> Bingo' : '--> Böp')
    puts("Resultat: #{UPNCalculator.new(word).calculate}") if valid
  end

  private

  # Returns the initialized automate with configuration according to our documentation
  def automate
    @automate ||= CellarAutomate.new(
      start: :q0,
      accepting: :q3,
      configuration: CONFIGURATION
    )
  end

  # Replaces all digits with 'D' and all operators with 'O'
  # @param [String] input
  def prepare_input(input)
    input.gsub(/\d/, 'D').gsub(/[#{UPNCalculator::ALLOWED_OPERATIONS}]/, 'O')
  end
end

Main.new.run
