#!/usr/bin/env ruby

# Quick test to verify expression UI implementation
require_relative 'lib/flipper'
require_relative 'lib/flipper/ui'

# Configure expression properties for testing
Flipper::UI.configure do |config|
  config.expression_properties = {
    'plan' => { type: 'string' },
    'age' => { type: 'number' }
  }
end

# Set up an in-memory adapter
Flipper.configure do |config|
  config.default { Flipper.new(Flipper::Adapters::Memory.new) }
end

# Test the decorator methods
feature = Flipper[:test_feature]
decorated_feature = Flipper::UI::Decorators::Feature.new(feature)

puts "=== Testing feature decorator methods ==="
puts "has_expression? (initially): #{decorated_feature.has_expression?}"
puts "expression_summary (initially): #{decorated_feature.expression_summary}"
puts "expression_description (initially): #{decorated_feature.expression_description}"

# Enable an expression
expression = Flipper.property(:plan).eq("basic")
feature.enable_expression(expression)

puts "\n=== After enabling expression ==="
puts "has_expression?: #{decorated_feature.has_expression?}"
puts "expression_summary: #{decorated_feature.expression_summary}"
puts "expression_description: #{decorated_feature.expression_description}"

# Test gates_in_words includes expression
puts "\n=== Testing gates_in_words ==="
puts "gates_in_words: #{decorated_feature.gates_in_words}"

# Test with a different expression type
feature.disable_expression
feature.enable_expression(Flipper.property(:age).gte(21))

puts "\n=== After enabling age >= 21 expression ==="
puts "expression_summary: #{decorated_feature.expression_summary}"
puts "expression_description: #{decorated_feature.expression_description}"
puts "gates_in_words: #{decorated_feature.gates_in_words}"

puts "\n=== All tests completed successfully! ==="
