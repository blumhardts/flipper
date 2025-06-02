#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'flipper'
require 'flipper/ui'

# Basic validation
puts "Validating ExpressionGate action implementation..."

begin
  require 'flipper/ui/actions/expression_gate'
  puts "✓ Successfully loaded ExpressionGate action"
rescue => e
  puts "✗ Failed to load ExpressionGate action: #{e.message}"
  puts e.backtrace.first(5).join("\n")
  exit 1
end

action_class = Flipper::UI::Actions::ExpressionGate

# Check if class is properly defined
puts "✓ ExpressionGate class is defined"

# Check if it has the right superclass
if action_class.superclass == Flipper::UI::Action
  puts "✓ ExpressionGate inherits from UI::Action"
else
  puts "✗ ExpressionGate does not inherit from UI::Action"
  exit 1
end

# Check if it includes FeatureNameFromRoute
if action_class.included_modules.include?(Flipper::UI::Action::FeatureNameFromRoute)
  puts "✓ ExpressionGate includes FeatureNameFromRoute"
else
  puts "✗ ExpressionGate does not include FeatureNameFromRoute"
  exit 1
end

# Check if route is defined
begin
  regex = action_class.route_regex
  puts "✓ Route regex is defined: #{regex}"
rescue => e
  puts "✗ Route regex is not defined: #{e.message}"
  exit 1
end

# Test route matching
test_paths = [
  '/features/test/expression',
  '/features/test/expression/',
  '/features/test%20with%20spaces/expression',
  '/features/test',
  '/features/test/actors'
]

puts "\nTesting route matching:"
test_paths.each do |path|
  matches = action_class.route_match?(path)
  puts "  #{path}: #{matches}"
end

# Test that methods exist
required_methods = [:post, :delete, :parse_expression_params]
required_methods.each do |method|
  if action_class.instance_methods(false).include?(method)
    puts "✓ Method #{method} is defined"
  else
    puts "✗ Method #{method} is not defined"
    exit 1
  end
end

puts "\n✅ All validations passed!"
