# frozen_string_literal: true

require 'active_support/core_ext/array/grouping'
require 'yaml'

# Configuration definition for a turing machine
class Configuration
  attr_reader :config

  def self.from_file(path)
    extension = File.extname(path)
    if %w[.yaml .yml].include? extension
      from_yaml_file(path)
    elsif extension == '.tmc'
      from_binary_file(path)
    end
  end

  def self.from_binary_file(path)
    Configuration.new(Config::BinaryDecoder.new(File.read(path)).call)
  end

  def self.from_yaml_file(path)
    Configuration.new(
      YAML.safe_load(
        File.read(path),
        [Symbol]
      )[:machine].freeze
    )
  end

  def initialize(config)
    @config = config
  end

  def write(path)
    File.open(path, 'w') do |file|
      binary_encode = Config::BinaryEncoder.new(@config).call
      file.write(binary_encode)
    end
  end
end
