#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/turing_machine'
require_relative 'lib/tape'
require 'yaml'

# Main entry point of application
class Main
  CONFIGURATION = YAML.safe_load(
    File.read('./configuration.yml'),
    [Symbol]
  )[:machine].freeze

  def run
    puts 'Geben Sie den Band-Inhalt ein: '

    tape = Tape.new(gets.chomp.gsub(/\s/, '').split(''))
    valid = machine.run(tape)

    puts(valid ? '=> Bingo'.bold : '=> Böp')
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
