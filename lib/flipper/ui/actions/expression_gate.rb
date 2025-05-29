require 'flipper/ui/action'
require 'flipper/ui/decorators/feature'
require 'flipper/ui/util'
require 'flipper/ui/configuration/expression_properties'

module Flipper
  module UI
    module Actions
      class ExpressionGate < UI::Action
        include FeatureNameFromRoute

        route %r{\A/features/(?<feature_name>.*)/expression/?\Z}

        def post
          render_read_only if read_only?

          feature = flipper[feature_name]

          case params['operation']
          when 'enable'
            begin
              validate_expression_params
              expression = Flipper::Expression.build(parse_expression_params)
              feature.enable_expression expression
            rescue ArgumentError => e
              error = "Invalid expression: #{e.message}"
              redirect_to("/features/#{Flipper::UI::Util.escape feature.key}?error=#{Flipper::UI::Util.escape error}")
              return
            end
          when 'disable'
            feature.disable_expression
          end

          redirect_to("/features/#{Flipper::UI::Util.escape feature.key}")
        end

        def delete
          render_read_only if read_only?

          feature = flipper[feature_name]
          feature.disable_expression

          redirect_to("/features/#{Flipper::UI::Util.escape feature.key}")
        end

        private

        def validate_expression_params
          property = params['expression_property'].to_s.strip
          operator = params['expression_operator'].to_s.strip
          value = params['expression_value'].to_s.strip

          if property.empty? || operator.empty? || value.empty?
            raise ArgumentError, "Property, operator, and value are all required"
          end

          properties = UI.configuration.expression_properties

          # Skip detailed validation if no properties are configured (for backward compatibility)
          return if properties.nil? || properties.empty?

          unless UI::Configuration::ExpressionProperties.valid_property?(properties, property)
            raise ArgumentError, "Property '#{property}' is not configured"
          end

          unless UI::Configuration::ExpressionProperties.valid_operator_for_property?(properties, property, operator)
            property_type = UI::Configuration::ExpressionProperties.type_for(properties, property)
            valid_operators = UI::Configuration::ExpressionProperties.valid_operators_for_type(property_type)
            raise ArgumentError, "Operator '#{operator}' is not valid for property '#{property}' of type '#{property_type}'. Valid operators: #{valid_operators.join(', ')}"
          end

          property_type = UI::Configuration::ExpressionProperties.type_for(properties, property)
          unless UI::Configuration::ExpressionProperties.validate_value_for_type(value, property_type)
            raise ArgumentError, "Value '#{value}' is not valid for property type '#{property_type}'"
          end
        end

        def parse_expression_params
          property = params['expression_property'].to_s.strip
          operator = params['expression_operator'].to_s.strip
          value = params['expression_value'].to_s.strip

          # Convert value to appropriate type based on property type (if configured)
          properties = UI.configuration.expression_properties
          property_type = properties&.key?(property) ? UI::Configuration::ExpressionProperties.type_for(properties, property) : nil

          parsed_value = if property_type
            case property_type
            when 'boolean'
              value == 'true'
            when 'number'
              value.include?('.') ? value.to_f : value.to_i
            else # string
              value
            end
          else
            # Fallback to original parsing logic when no properties configured
            case value
            when /\A\d+\z/
              value.to_i
            when /\A\d+\.\d+\z/
              value.to_f
            when 'true'
              true
            when 'false'
              false
            else
              value
            end
          end

          # Map operator to expression type
          operator_mapping = {
            'eq' => 'Equal',
            'ne' => 'NotEqual',
            'gt' => 'GreaterThan',
            'gte' => 'GreaterThanOrEqualTo',
            'lt' => 'LessThan',
            'lte' => 'LessThanOrEqualTo'
          }

          expression_type = operator_mapping[operator]
          unless expression_type
            raise ArgumentError, "Unsupported operator: #{operator}"
          end

          # Build expression hash in the format: {"Equal": [{"Property": ["plan"]}, "basic"]}
          {
            expression_type => [
              { "Property" => [property] },
              parsed_value
            ]
          }
        end
      end
    end
  end
end
