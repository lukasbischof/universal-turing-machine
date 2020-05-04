# frozen_string_literal: true

module Config
  # Decodes a binary turing machine configuration file content
  class BinaryDecoder
    def initialize(file_content)
      @file_content = file_content
      @config_hash = {}
      @decoded_states = Set.new
    end

    def call
      parse @file_content.unpack('C*').flat_map { |byte| decode_byte(byte) }.join
      ensure_all_states_included

      @config_hash
    end

    private

    def ensure_all_states_included
      @decoded_states.each do |state|
        @config_hash[state] = {} unless @config_hash.keys.include? state
      end
    end

    def parse(string_representation)
      string_representation.split('111').first.split('11') do |transition|
        parse_transition(transition)
      end
    end

    # rubocop:disable Metrics/MethodLength
    def parse_transition(transition)
      arguments = transition.split('1')
      initial_state = decode_state arguments.shift
      tape_read = decode_tape_symbol arguments.shift
      transitioning_state = decode_state arguments.shift
      tape_write = decode_tape_symbol arguments.shift
      movement = decode_movement arguments.shift

      transition = TuringMachine.transition(
        transitioning_state,
        tape_write,
        movement
      )

      register_transition(initial_state, tape_read, transition)
    end
    # rubocop:enable Metrics/MethodLength

    def register_transition(initial_state, tape_read, transition)
      unless @config_hash.keys.include? initial_state
        @config_hash[initial_state] = {}
      end

      @config_hash[initial_state][tape_read] = transition
    end

    def decode_byte(byte)
      8.times.map.with_index { |_element, i| byte >> (7 - i) & 0b1 }
    end

    def decode_movement(unary)
      if decode(unary) == 1
        :right
      else
        :left
      end
    end

    def decode_tape_symbol(unary)
      decoded = decode(unary)
      return nil if decoded.zero?

      (decoded - 1).to_s
    end

    def decode_state(unary)
      state = :"q#{decode(unary)}"
      @decoded_states.add(state)

      state
    end

    def decode(unary)
      unary.length - 1
    end
  end
end
