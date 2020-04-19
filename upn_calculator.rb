# frozen_string_literal: true

class UPNCalculator
  ALLOWED_OPERATIONS = '\+\-\*'
  OPERATION_REGEXP = /\d{2}[#{ALLOWED_OPERATIONS}]/.freeze

  def initialize(expression)
    @expression = expression
  end

  def calculate
    eval_expression while OPERATION_REGEXP =~ @expression

    @expression
  end

  private

  def eval_expression
    match = @expression.match(OPERATION_REGEXP)[0]
    result = eval <<~RUBY, binding, __FILE__, __LINE__ + 1
      #{match[0]}#{match[2]}#{match[1]}
    RUBY

    @expression.sub!(match, result.to_s)
  end
end
