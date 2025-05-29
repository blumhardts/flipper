#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'flipper'
require 'flipper/ui'
require 'rack/test'
require 'rack/session'

class TestApp
  include Rack::Test::Methods

  def app
    @app ||= Flipper::UI.app(flipper) do |builder|
      builder.use Rack::Session::Cookie, secret: 'test' * 16
    end
  end

  def flipper
    @flipper ||= Flipper.new(Flipper::Adapters::Memory.new)
  end

  def run_tests
    puts "Testing Expression Gate Action Integration..."

    # Test POST enable
    flipper.disable :test_feature
    response = post '/features/test_feature/expression', {
      'operation' => 'enable',
      'expression_property' => 'plan',
      'expression_operator' => 'eq',
      'expression_value' => 'basic',
      'authenticity_token' => 'test'
    }

    if last_response.status == 302
      puts "✓ POST enable returns redirect (#{last_response.status})"
    else
      puts "✗ POST enable failed (#{last_response.status})"
      puts "Response: #{last_response.body}"
      return false
    end

    # Check if expression was enabled
    if flipper.feature(:test_feature).enabled_gate_names.include?(:expression)
      puts "✓ Expression gate was enabled"
    else
      puts "✗ Expression gate was not enabled"
      return false
    end

    # Test DELETE disable
    response = delete '/features/test_feature/expression', {
      'authenticity_token' => 'test'
    }

    if last_response.status == 302
      puts "✓ DELETE disable returns redirect (#{last_response.status})"
    else
      puts "✗ DELETE disable failed (#{last_response.status})"
      puts "Response: #{last_response.body}"
      return false
    end

    # Check if expression was disabled
    if !flipper.feature(:test_feature).enabled_gate_names.include?(:expression)
      puts "✓ Expression gate was disabled"
    else
      puts "✗ Expression gate was not disabled"
      return false
    end

    puts "\n✅ All integration tests passed!"
    true
  end
end

begin
  test_app = TestApp.new
  success = test_app.run_tests
  exit success ? 0 : 1
rescue => e
  puts "✗ Integration test failed with error: #{e.message}"
  puts e.backtrace.first(5).join("\n")
  exit 1
end
