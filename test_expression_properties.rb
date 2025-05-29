#!/usr/bin/env ruby

require_relative 'lib/flipper/ui/configuration'

# Test basic configuration
config = Flipper::UI::Configuration.new
puts "Default expression_properties: #{config.expression_properties}"

# Test setting expression properties
config.expression_properties = { user_id: { type: 'string' }, is_premium: { type: 'boolean' } }
puts "Set expression_properties: #{config.expression_properties}"

# Test UI delegation
require_relative 'lib/flipper/ui'
puts "UI expression_properties: #{Flipper::UI.expression_properties}"

# Test validation methods
require_relative 'lib/flipper/ui/configuration/expression_properties'

properties = { user_id: { type: 'string' }, age: { type: 'number' } }
Flipper::UI::Configuration::ExpressionProperties.validate_properties(properties)
puts "Validation passed!"

puts "Type for user_id: #{Flipper::UI::Configuration::ExpressionProperties.type_for(properties, :user_id)}"
puts "Property names: #{Flipper::UI::Configuration::ExpressionProperties.property_names(properties)}"

puts "All tests passed!"
