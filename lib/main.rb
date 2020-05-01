# frozen_string_literal: true

require 'yaml'
require 'colorize'

# Main entry point of application
class Main
  CONFIGURATION = YAML.safe_load(
    File.read('./configuration.yml'),
    [Symbol]
  )[:machine].freeze

  class << self
    private

    def machine(tape)
      TuringMachine.new(
        start: :q0,
        accepting: :q3,
        configuration: CONFIGURATION,
        tape: tape
      )
    end

    def logger
      Logger.instance
    end
  end

  def self.run
    logger.log 'Geben Sie den Band-Inhalt ein: '

    # tape = Tape.new(gets.chomp.gsub(/\s/, '').split(''))
    tape = Tape.new(%w[0 1 0 0 1 1])
    valid = machine(tape).run

    logger.log(valid ? '=> Bingo'.bold : '=> Böp')
  end
end
