# frozen_string_literal: true

require 'yaml'

# Main entry point of application
class Main
  CONFIGURATION = YAML.safe_load(
    File.read('./configuration.yml'),
    [Symbol]
  )[:machine].freeze

  class << self
    private

    def machine
      TuringMachine.new(
        start: :q0,
        accepting: :q3,
        configuration: CONFIGURATION
      )
    end
  end

  def self.run
    puts 'Geben Sie den Band-Inhalt ein: '

    # tape = Tape.new(gets.chomp.gsub(/\s/, '').split(''))
    tape = Tape.new(%w[0 1 0 0 1 1])
    valid = machine.run(tape)

    puts(valid ? '=> Bingo'.bold : '=> Böp')
  end
end
