# frozen_string_literal: true

# Wrapper class which handles logging using strategies
# to control logging level
class Logger
  QUIET = :quiet
  VERBOSE = :verbose

  attr_accessor :strategy

  # rubocop:disable Style/GlobalVars
  def self.default
    $logger ||= Logger.new(strategy: VERBOSE)
  end
  # rubocop:enable Style/GlobalVars

  def initialize(strategy:)
    @strategy = strategy
  end

  def log(message = nil)
    puts message
  end

  def verbose_log(message = nil)
    log message if verbose?
  end

  private

  def verbose?
    @strategy == :verbose
  end
end
