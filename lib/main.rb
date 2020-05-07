# frozen_string_literal: true

require 'yaml'
require 'colorize'

# Main entry point of application
class Main
  CONFIGURATION = Configuration.from_file('./configuration.tmc')

  class << self
    private

    def machine(tape)
      TuringMachine.new(
        start: :q0,
        accepting: :q1,
        configuration: CONFIGURATION,
        tape: tape
      )
    end

    def logger
      Logger.instance
    end
  end

  def self.run
    logger.verbose_log "Gelesene TM Konfiguration: #{CONFIGURATION.config}"
    logger.log 'Geben Sie den Band-Inhalt ein: '

    # tape = Tape.new(%w[0 1 0 0 1 1])
    tape = Tape.new(read_tape_content)
    valid = machine(tape).run

    logger.log(valid ? '=> Bingo'.bold : '=> Böp')
  end

  private_class_method def self.read_tape_content
    gets.chomp.gsub(/\s/, '').split('')
  end
end
