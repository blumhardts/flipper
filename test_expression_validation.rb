#!/usr/bin/env ruby

require 'bundler/setup'
require_relative 'lib/flipper'
require_relative 'lib/flipper/ui'
require_relative 'lib/flipper/ui/configuration/expression_properties'

# Configure some test properties
Flipper::UI.configure do |config|
  config.expression_properties = {
    'plan' => { type: 'string' },
    'user_count' => { type: 'number' },
    'premium' => { type: 'boolean' }
  }
end

# Test the validation helpers
properties = Flipper::UI.configuration.expression_properties

puts "Testing expression property validation helpers..."

# Test valid property
puts "Valid property 'plan': #{Flipper::UI::Configuration::ExpressionProperties.valid_property?(properties, 'plan')}"
puts "Invalid property 'unknown': #{Flipper::UI::Configuration::ExpressionProperties.valid_property?(properties, 'unknown')}"

# Test valid operators
puts "Valid operator 'eq': #{Flipper::UI::Configuration::ExpressionProperties.valid_operator?('eq')}"
puts "Invalid operator 'invalid': #{Flipper::UI::Configuration::ExpressionProperties.valid_operator?('invalid')}"

# Test operator validity for property types
puts "String property 'plan' with 'eq': #{Flipper::UI::Configuration::ExpressionProperties.valid_operator_for_property?(properties, 'plan', 'eq')}"
puts "String property 'plan' with 'gt': #{Flipper::UI::Configuration::ExpressionProperties.valid_operator_for_property?(properties, 'plan', 'gt')}"
puts "Number property 'user_count' with 'gt': #{Flipper::UI::Configuration::ExpressionProperties.valid_operator_for_property?(properties, 'user_count', 'gt')}"
puts "Boolean property 'premium' with 'eq': #{Flipper::UI::Configuration::ExpressionProperties.valid_operator_for_property?(properties, 'premium', 'eq')}"
puts "Boolean property 'premium' with 'gt': #{Flipper::UI::Configuration::ExpressionProperties.valid_operator_for_property?(properties, 'premium', 'gt')}"

# Test value validation
puts "String value 'basic' for string type: #{Flipper::UI::Configuration::ExpressionProperties.validate_value_for_type('basic', 'string')}"
puts "Number value '100' for number type: #{Flipper::UI::Configuration::ExpressionProperties.validate_value_for_type('100', 'number')}"
puts "Number value '100.5' for number type: #{Flipper::UI::Configuration::ExpressionProperties.validate_value_for_type('100.5', 'number')}"
puts "Boolean value 'true' for boolean type: #{Flipper::UI::Configuration::ExpressionProperties.validate_value_for_type('true', 'boolean')}"
puts "Boolean value 'false' for boolean type: #{Flipper::UI::Configuration::ExpressionProperties.validate_value_for_type('false', 'boolean')}"
puts "Invalid boolean value 'maybe' for boolean type: #{Flipper::UI::Configuration::ExpressionProperties.validate_value_for_type('maybe', 'boolean')}"

puts "All tests completed!"
