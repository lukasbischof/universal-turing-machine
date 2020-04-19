# frozen_string_literal: true

# Implementation of a calculator,
# which returns the result of a reversed polish notation expression
class UPNCalculator
  ALLOWED_OPERATIONS = '\+\-\*'
  OPERATION_REGEXP = /\d{2}[#{ALLOWED_OPERATIONS}]/.freeze

  # @param [String] expression
  def initialize(expression)
    @expression = expression
  end

  def calculate
    eval_expression while OPERATION_REGEXP =~ @expression

    @expression
  end

  private

  # Evaluates the next possible expression
  # which is DDO.
  # For example, if the string is 23+12++
  # it replaces 23+ with 5 and returns 512++
  # which would then be evaluated to 53+
  # which then returns 8
  def eval_expression
    match = @expression.match(OPERATION_REGEXP)[0]
    result = eval <<~RUBY, binding, __FILE__, __LINE__ + 1
      #{match[0]}#{match[2]}#{match[1]}
    RUBY

    @expression.sub!(match, result.to_s)
  end
end
