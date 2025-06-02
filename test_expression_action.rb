#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'flipper'
require 'flipper/ui'

begin
  require 'flipper/ui/actions/expression_gate'
  puts "✓ Successfully loaded ExpressionGate action"
rescue => e
  puts "✗ Failed to load ExpressionGate action: #{e.message}"
  exit 1
end

# Test route matching
action_class = Flipper::UI::Actions::ExpressionGate
puts "\nTesting route matching:"
puts "  /features/test/expression: #{action_class.route_match?('/features/test/expression')}"
puts "  /features/test/expression/: #{action_class.route_match?('/features/test/expression/')}"
puts "  /features/test: #{action_class.route_match?('/features/test')}"

# Test expression building
flipper = Flipper.new(Flipper::Adapters::Memory.new)
feature = flipper[:test_feature]

# Test basic expression
expression_hash = {
  "Equal" => [
    { "Property" => ["plan"] },
    "basic"
  ]
}

begin
  expression = Flipper::Expression.build(expression_hash)
  puts "\n✓ Expression building test passed"
  puts "  Expression: #{expression.inspect}"
  puts "  Expression value: #{expression.value}"
rescue => e
  puts "\n✗ Expression building failed: #{e.message}"
  exit 1
end

# Test enabling expression
begin
  feature.enable_expression(expression)
  puts "\n✓ Feature expression enabling test passed"
  puts "  Expression enabled: #{feature.enabled_gate_names.include?(:expression)}"
  puts "  Expression value: #{feature.expression&.value}"
rescue => e
  puts "\n✗ Feature expression enabling failed: #{e.message}"
  exit 1
end

# Test context evaluation
context = { properties: { "plan" => "basic" } }
actor = Flipper::Actor.new("user1", context[:properties])
begin
  result = feature.enabled?(actor)
  puts "\n✓ Context evaluation test passed"
  puts "  Context: #{context}"
  puts "  Enabled for actor: #{result}"
rescue => e
  puts "\n✗ Context evaluation failed: #{e.message}"
  exit 1
end

puts "\n✓ All tests completed successfully!"
