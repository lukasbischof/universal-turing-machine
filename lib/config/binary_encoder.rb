# frozen_string_literal: true

module Config
  # Encodes a TM configuration using the structure explained in lecture
  class BinaryEncoder
    def initialize(config)
      @config = config
    end

    def call
      binary_string_representation.split('').map(&:to_i).in_groups_of(8).map do |byte|
        binary_encode_bits_array byte
      end.pack('C*')
    end

    def binary_string_representation
      output = ''.dup

      @config.each do |state, transition_functions|
        transition_functions.each do |tape_symbol, transition_function|
          output << encode_state(state)
          output << encode_tape_symbol(tape_symbol)
          output << encode_state(transition_function[0])
          output << encode_tape_symbol(transition_function[1])
          output << encode_tape_movement(transition_function[2])
          output << '1'
        end
      end

      output + '1'
    end

    def binary_encode_bits_array(byte)
      8.times.reduce(0) { |sum, i| sum + ((byte[i] || 0) << (7 - i)) }
    end

    def encode_tape_movement(direction)
      if direction == :right
        encode(1)
      else
        encode(0)
      end
    end

    def encode_tape_symbol(symbol)
      encode(symbol&.to_i&.+(1))
    end

    def encode_state(state_string)
      encode(state_string[1..])
    end

    def encode(number)
      unary(number.to_i + 1) + '1'
    end

    def unary(number)
      '0' * number
    end
  end
end
