#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'flipper'
require 'flipper/ui'
require 'rack/test'

# Create a simple app and test the route
app = Flipper::UI.app(Flipper.new(Flipper::Adapters::Memory.new))

puts "Testing expression gate route resolution..."

# Mock a request
class MockRequest
  attr_reader :path_info
  
  def initialize(path)
    @path_info = path
  end
end

# Get the middleware and test action resolution
middleware = Flipper::UI::Middleware.new(nil)
action_collection = middleware.instance_variable_get(:@action_collection)

test_request = MockRequest.new('/features/test/expression')
action_class = action_collection.action_for_request(test_request)

if action_class
  puts "✓ Route '/features/test/expression' resolved to: #{action_class}"
  
  if action_class == Flipper::UI::Actions::ExpressionGate
    puts "✓ Correct action class resolved"
  else
    puts "✗ Wrong action class resolved"
    exit 1
  end
else
  puts "✗ Route '/features/test/expression' did not resolve to any action"
  exit 1
end

# Test other routes to make sure they don't match
test_request2 = MockRequest.new('/features/test/actors')
action_class2 = action_collection.action_for_request(test_request2)

if action_class2 == Flipper::UI::Actions::ActorsGate
  puts "✓ Actors route still works correctly"
else
  puts "✗ Actors route resolution broken"
  exit 1
end

puts "\n✅ Basic functionality test passed!"
