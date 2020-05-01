# frozen_string_literal: true

# Implementation of a turing machine
class TuringMachine
  def self.transition(new_state, write_operation, movement_operation)
    [new_state, write_operation, movement_operation]
  end

  # @param [Symbol] start
  # @param [Symbol] accepting
  # @param [Hash] configuration
  # @param [Tape] tape
  def initialize(start:, accepting:, configuration:, tape:)
    @configuration = configuration
    @current_state = start
    @accepting = accepting
    @tape = tape
  end

  def run
    while (current_transition = next_transition)
      apply_transition(current_transition)
    end

    @current_state == @accepting
  end

  private

  # @param [Hash] transition
  def apply_transition(transition)
    log_transition(transition)

    new_state, write_operation, movement_operation = transition

    @current_state = new_state
    @tape.write write_operation
    @tape.move movement_operation
  end

  def next_transition
    input_character = @tape.read
    find_next_step(input_character)&.values&.first
  end

  # @param [String] input_character
  def find_next_step(input_character)
    current_config.select do |config, _transition|
      config == input_character
    end
  end

  def current_config
    @configuration[@current_state]
  end

  def log_transition(transition)
    Logger.instance.verbose_log <<~LOG
      Current Tape:
      #{@tape}
      --> Applying transition #{transition}

    LOG
  end
end
