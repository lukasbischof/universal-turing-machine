#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/turing_machine'
require_relative 'lib/tape'

# Main entry point of application
class Main
  CONFIGURATION = {
    q0: {
      '1' => TuringMachine.transition(:q0, '1', :right),
      '0' => TuringMachine.transition(:q1, '0', :right)
    },
    q1: {
      '1' => TuringMachine.transition(:q0, '1', :right),
      '0' => TuringMachine.transition(:q2, '0', :right)
    },
    q2: {
      '0' => TuringMachine.transition(:q2, '0', :right),
      '1' => TuringMachine.transition(:q2, '1', :right),
      nil => TuringMachine.transition(:q3, nil, :right)
    },
    q3: {}
  }.freeze

  def run
    puts 'Geben Sie den Band-Inhalt ein: '

    tape = Tape.new(gets.chomp.gsub(/\s/, '').split(''))
    valid = machine.run(tape)

    puts(valid ? '--> Bingo' : '--> Böp')
  end

  private

  def machine
    @machine ||= TuringMachine.new(
      start: :q0,
      accepting: :q3,
      configuration: CONFIGURATION
    )
  end
end

Main.new.run
