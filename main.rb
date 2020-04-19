#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'celler_automate'
require_relative 'upn_calculator'

class Main
  CONFIGURATION = {
    q0: {
      %w[D $] => [:q0, %w[D $]],
      %w[D D] => [:q0, %w[D D]],
      %w[O D] => [:q1, []]
    },
    q1: {
      %w[O D] => [:q1, []],
      %w[D D] => [:q0, %w[D D]],
      [nil, 'D'] => [:q2, []]
    },
    q2: {
      [nil, '$'] => [:q3, []]
    },
    q3: {}
  }.freeze

  def run
    puts 'Geben Sie Ihr Wort ein: '

    word = gets.chomp.gsub(/\s/, '')

    prepared_input = prepare_input(word)
    valid = automate.run(prepared_input)

    puts(valid ? '--> Bingo' : '--> Böp')
    puts("Resultat: #{UPNCalculator.new(word).calculate}") if valid
  end

  private

  def automate
    @automate ||= CellarAutomate.new(
      start: :q0,
      accepting: :q3,
      configuration: CONFIGURATION
    )
  end

  def prepare_input(input)
    input.gsub(/\d/, 'D').gsub(/[#{UPNCalculator::ALLOWED_OPERATIONS}]/, 'O')
  end
end

Main.new.run
