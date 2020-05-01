# frozen_string_literal: true

require 'singleton'

# Wrapper class which handles logging using strategies
# to control logging level
class Logger
  include Singleton

  QUIET = :quiet
  VERBOSE = :verbose

  attr_accessor :strategy

  def initialize(strategy: VERBOSE)
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
