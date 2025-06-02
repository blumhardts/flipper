#!/usr/bin/env ruby

require 'bundler/setup'
require_relative 'lib/flipper'
require_relative 'lib/flipper/ui'
require_relative 'lib/flipper/ui/actions/expression_gate'

puts "Testing Expression Form Validation..."

# Configure test properties
Flipper::UI.configure do |config|
  config.expression_properties = {
    'plan' => { type: 'string' },
    'user_count' => { type: 'number' },
    'premium' => { type: 'boolean' }
  }
end

flipper = Flipper.new(Flipper::Adapters::Memory.new)

# Create a mock action for testing validation
class TestExpressionGate < Flipper::UI::Actions::ExpressionGate
  attr_accessor :test_params
  
  def initialize(flipper, params = {})
    super(flipper, double('request'))
    @test_params = params
  end
  
  def params
    @test_params
  end
end

action = TestExpressionGate.new(flipper)

# Test 1: Valid string property with eq operator
puts "\n=== Test 1: Valid string property ==="
action.test_params = {
  'expression_property' => 'plan',
  'expression_operator' => 'eq', 
  'expression_value' => 'basic'
}

begin
  action.send(:validate_expression_params)
  puts "✓ Valid string property validation passed"
rescue => e
  puts "✗ Valid string property validation failed: #{e.message}"
end

# Test 2: Invalid property name
puts "\n=== Test 2: Invalid property name ==="
action.test_params = {
  'expression_property' => 'unknown_property',
  'expression_operator' => 'eq',
  'expression_value' => 'basic'
}

begin
  action.send(:validate_expression_params)
  puts "✗ Invalid property validation should have failed"
rescue => e
  puts "✓ Invalid property validation failed as expected: #{e.message}"
end

# Test 3: Invalid operator for boolean property
puts "\n=== Test 3: Invalid operator for boolean ==="
action.test_params = {
  'expression_property' => 'premium',
  'expression_operator' => 'gt',
  'expression_value' => 'true'
}

begin
  action.send(:validate_expression_params)
  puts "✗ Invalid operator validation should have failed"
rescue => e
  puts "✓ Invalid operator validation failed as expected: #{e.message}"
end

# Test 4: Invalid value for boolean property
puts "\n=== Test 4: Invalid value for boolean ==="
action.test_params = {
  'expression_property' => 'premium',
  'expression_operator' => 'eq',
  'expression_value' => 'maybe'
}

begin
  action.send(:validate_expression_params)
  puts "✗ Invalid boolean value validation should have failed"
rescue => e
  puts "✓ Invalid boolean value validation failed as expected: #{e.message}"
end

# Test 5: Valid number property with gt operator
puts "\n=== Test 5: Valid number property ==="
action.test_params = {
  'expression_property' => 'user_count',
  'expression_operator' => 'gt',
  'expression_value' => '100'
}

begin
  action.send(:validate_expression_params)
  puts "✓ Valid number property validation passed"
rescue => e
  puts "✗ Valid number property validation failed: #{e.message}"
end

# Test 6: Invalid value for number property
puts "\n=== Test 6: Invalid value for number ==="
action.test_params = {
  'expression_property' => 'user_count',
  'expression_operator' => 'gt',
  'expression_value' => 'not_a_number'
}

begin
  action.send(:validate_expression_params)
  puts "✗ Invalid number value validation should have failed"
rescue => e
  puts "✓ Invalid number value validation failed as expected: #{e.message}"
end

# Test 7: Empty values
puts "\n=== Test 7: Empty values ==="
action.test_params = {
  'expression_property' => '',
  'expression_operator' => 'eq',
  'expression_value' => 'basic'
}

begin
  action.send(:validate_expression_params)
  puts "✗ Empty property validation should have failed"
rescue => e
  puts "✓ Empty property validation failed as expected: #{e.message}"
end

# Test 8: Value parsing with type conversion
puts "\n=== Test 8: Value parsing with type conversion ==="
action.test_params = {
  'expression_property' => 'user_count',
  'expression_operator' => 'eq',
  'expression_value' => '42'
}

begin
  result = action.send(:parse_expression_params)
  parsed_value = result['Equal'][1]
  if parsed_value == 42 && parsed_value.is_a?(Integer)
    puts "✓ Number parsing converted correctly: #{parsed_value.inspect}"
  else
    puts "✗ Number parsing failed: #{parsed_value.inspect}"
  end
rescue => e
  puts "✗ Number parsing failed: #{e.message}"
end

action.test_params = {
  'expression_property' => 'premium',
  'expression_operator' => 'eq',
  'expression_value' => 'true'
}

begin
  result = action.send(:parse_expression_params)
  parsed_value = result['Equal'][1]
  if parsed_value == true && parsed_value.is_a?(TrueClass)
    puts "✓ Boolean parsing converted correctly: #{parsed_value.inspect}"
  else
    puts "✗ Boolean parsing failed: #{parsed_value.inspect}"
  end
rescue => e
  puts "✗ Boolean parsing failed: #{e.message}"
end

puts "\nAll validation tests completed!"
